using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Channels;

namespace E9XSim.connection
{
    public sealed class CanTcpTransport : IDisposable
    {
        private readonly int _port;

        private readonly ConcurrentQueue<CanTcpPacket> _incoming = new();

        private readonly Channel<CanTcpPacket> _outgoing =
            Channel.CreateUnbounded<CanTcpPacket>();

        private readonly TcpListener _listener;

        private readonly CancellationTokenSource _cts = new();

        private readonly Task _serverTask;

        public bool IsConnected { get; private set; }

        public CanTcpTransport(int port)
        {
            _port = port;

            _listener = new TcpListener(
                IPAddress.Any,
                _port);

            _listener.Start();

            _serverTask = Task.Run(
                () => ServerLoop(_cts.Token));
        }

        public void QueueOutgoing(CanTcpPacket packet)
        {
            _outgoing.Writer.TryWrite(packet);
        }

        public bool TryReceive(out CanTcpPacket packet)
        {
            return _incoming.TryDequeue(out packet);
        }

        private async Task ServerLoop(
            CancellationToken cancellationToken)
        {
            while (!cancellationToken.IsCancellationRequested)
            {
                try
                {
                    using TcpClient client =
                        await _listener.AcceptTcpClientAsync(
                            cancellationToken);

                    client.NoDelay = true;

                    IsConnected = true;

                    using NetworkStream stream =
                        client.GetStream();

                    using var connectionCts =
                        CancellationTokenSource
                            .CreateLinkedTokenSource(
                                cancellationToken);

                    Task sendTask =
                        SendLoop(
                            stream,
                            connectionCts.Token);

                    Task receiveTask =
                        ReceiveLoop(
                            stream,
                            connectionCts.Token);

                    await Task.WhenAny(
                        sendTask,
                        receiveTask);

                    connectionCts.Cancel();

                    try
                    {
                        await Task.WhenAll(
                            sendTask,
                            receiveTask);
                    }
                    catch (OperationCanceledException)
                    {
                    }
                }
                catch (OperationCanceledException)
                {
                    break;
                }
                catch (SocketException)
                {
                    if (cancellationToken.IsCancellationRequested)
                        break;
                }
                finally
                {
                    IsConnected = false;
                }
            }
        }

        private async Task SendLoop(
            NetworkStream stream,
            CancellationToken cancellationToken)
        {
            await foreach (
                CanTcpPacket packet in
                _outgoing.Reader.ReadAllAsync(
                    cancellationToken))
            {
                byte[] bytes =
                    CanTcpCodec.Encode(packet);

                await stream.WriteAsync(
                    bytes,
                    cancellationToken);
            }
        }

        private async Task ReceiveLoop(
            NetworkStream stream,
            CancellationToken cancellationToken)
        {
            byte[] buffer =
                new byte[CanTcpCodec.PacketSize];

            while (!cancellationToken.IsCancellationRequested)
            {
                bool success =
                    await ReadExactlyAsync(
                        stream,
                        buffer,
                        cancellationToken);

                if (!success)
                    return;

                CanTcpPacket packet =
                    CanTcpCodec.Decode(buffer);

                _incoming.Enqueue(packet);
            }
        }

        private static async Task<bool> ReadExactlyAsync(
            NetworkStream stream,
            byte[] buffer,
            CancellationToken cancellationToken)
        {
            int offset = 0;

            while (offset < buffer.Length)
            {
                int count =
                    await stream.ReadAsync(
                        buffer.AsMemory(
                            offset,
                            buffer.Length - offset),
                        cancellationToken);

                if (count == 0)
                    return false;

                offset += count;
            }

            return true;
        }

        public void Dispose()
        {
            _cts.Cancel();

            _outgoing.Writer.TryComplete();

            _listener.Stop();

            _cts.Dispose();
        }
    }
}

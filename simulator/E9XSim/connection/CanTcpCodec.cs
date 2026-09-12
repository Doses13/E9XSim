using System;
using System.Buffers.Binary;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace E9XSim.connection
{
    public static class CanTcpCodec
    {
        public const int PacketSize = 17;

        public const byte ProtocolVersion = 1;
        public const byte CanFrameMessageType = 1;

        public static byte[] Encode(
            CanTcpPacket packet)
        {
            if (packet.Dlc > 8)
                throw new ArgumentOutOfRangeException(
                    nameof(packet),
                    "Classic CAN DLC cannot exceed 8.");

            if (packet.Data.Length < packet.Dlc)
                throw new ArgumentException(
                    "Packet data is shorter than its DLC.");

            byte[] buffer = new byte[PacketSize];

            buffer[0] = ProtocolVersion;
            buffer[1] = CanFrameMessageType;
            buffer[2] = packet.Bus;
            buffer[3] = packet.Flags;

            BinaryPrimitives.WriteUInt32LittleEndian(
                buffer.AsSpan(4, 4),
                packet.Id);

            buffer[8] = packet.Dlc;

            packet.Data
                .AsSpan(0, packet.Dlc)
                .CopyTo(buffer.AsSpan(9, packet.Dlc));

            return buffer;
        }

        public static CanTcpPacket Decode(
            ReadOnlySpan<byte> data)
        {
            if (data.Length != PacketSize)
                throw new ArgumentException(
                    $"Expected {PacketSize} bytes.");

            if (data[0] != ProtocolVersion)
                throw new InvalidDataException(
                    $"Unsupported protocol version {data[0]}.");

            if (data[1] != CanFrameMessageType)
                throw new InvalidDataException(
                    $"Unsupported message type {data[1]}.");

            byte bus = data[2];
            byte flags = data[3];

            uint id =
                BinaryPrimitives.ReadUInt32LittleEndian(
                    data.Slice(4, 4));

            byte dlc = data[8];

            if (dlc > 8)
                throw new InvalidDataException(
                    $"Invalid CAN DLC {dlc}.");

            byte[] payload =
                data.Slice(9, dlc).ToArray();

            return new CanTcpPacket(
                bus,
                id,
                flags,
                dlc,
                payload);
        }
    }
}
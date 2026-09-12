using System;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using System.Security.RightsManagement;
using System.Text;

using E9XSim.modules.CAN;
using E9XSim.protocols.CAN;
using E9XSim.protocols.CAN.E9X.INFO_CON;

namespace E9XSim.modules.INFO_CON
{
    public sealed class ConModule : ISimModule
    {
        private readonly ICanBus _kcan;

        private byte _counter;
        public string Name => "CON";

        private int _pendingRotaryDelta = 0;

        private ConButton _pendingPressedButton = ConButton.None;
        private ConButton _pendingReleasedButton = ConButton.None;

        private bool _knobPressPending;
        private bool _knobReleasePending;

        private ConKnobTilt? _pendingTilt;
        private bool _pendingTiltRelease;

        public ModuleExecutionState ExecutionState {  get; private set; }
            = ModuleExecutionState.Running;

        public ConState State { get; } = new();

        public ConModule(ICanBus kcan)
        {
            _kcan = kcan;
        }

        public void Step(
            TimeSpan simulationTime,
            TimeSpan deltaTime)
        {
            if (_pendingRotaryDelta != 0)
            {
                State.RotaryPosition =
                    unchecked((ushort)(
                        State.RotaryPosition +
                        _pendingRotaryDelta));

                _kcan.Send(
                    Name,
                    ConProtocol.CreateRotaryFrame(
                        State.RotaryPosition,
                        NextCounter(),
                        simulationTime));

                _pendingRotaryDelta = 0;
            }

            if (_pendingPressedButton != ConButton.None)
            {
                _kcan.Send(
                    Name,
                    ConProtocol.CreateButtonFrame(
                        _pendingPressedButton,
                        ConInputState.Pressed,
                        NextCounter(),
                        simulationTime));

                _pendingPressedButton = ConButton.None;
            }

            if (_pendingReleasedButton != ConButton.None)
            {
                _kcan.Send(
                    Name,
                    ConProtocol.CreateButtonFrame(
                        _pendingReleasedButton,
                        ConInputState.Released,
                        NextCounter(),
                        simulationTime));

                _pendingReleasedButton = ConButton.None;
            }

            if (_pendingTilt.HasValue)
            {
                State.KnobTilt = _pendingTilt.Value;

                // Create actual BMW CON directional CAN frame here.

                _pendingTilt = null;
            }

            if (_pendingTiltRelease)
            {
                State.KnobTilt = ConKnobTilt.Center;

                // Send actual release/center frame here.

                _pendingTiltRelease = false;
            }
        }

        public void Rotate(int clicks)
        {
            _pendingRotaryDelta += clicks;
        }

        public void PressButton(ConButton button)
        {
            _pendingPressedButton = button;
        }

        public void ReleaseButton(ConButton button)
        {
            _pendingReleasedButton = button;
        }

        public void PressKnob()
        {
            _knobPressPending = true;
        }

        public void ReleaseKnob()
        {
            _knobReleasePending = true;
        }

        public void TiltKnob(ConKnobTilt direction)
        {
            _pendingTilt = direction;
        }

        public void ReleaseTilt()
        {
            _pendingTiltRelease = true;
        }


        private void Send(CanFrame frame)
        {
            _kcan.Send(Name, frame);
        }

        private byte NextCounter()
        {
            return _counter++;
        }
    }
}

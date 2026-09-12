using E9XSim.modules.CAN;
using System;
using System.Collections.Generic;
using System.Text;

namespace E9XSim.protocols.CAN.E9X.INFO_CON
{
    public enum ConInputState : byte
    {
        Released    = 0x00,
        Pressed     = 0x01,
        Held        = 0x02
    }

    public static class ConProtocol
    {
        public static CanFrame CreateButtonFrame(
            ConButton button,
            ConInputState state,
            byte counter,
            TimeSpan timestamp)
        {
            byte[] data =
                [
                    counter,
                    0x00,
                    0x00,
                    (byte)state,
                    0xC0,
                    (byte)button
                ];

            return new CanFrame(
                ConCanIds.Buttons,
                data,
                timestamp);
        }

        public static CanFrame CreateRotaryFrame(
            ushort position,
            byte counter,
            TimeSpan timestamp)
        {
            byte low = (byte)(position & 0xFF);
            byte high = (byte)(position >> 8);

            byte[] data =
                [
                    counter,
                    0x00,
                    0x00,
                    low,
                    high,
                    0x00
                ];

            return new CanFrame(
                ConCanIds.Rotary,
                data,
                timestamp);
        }

    }
}

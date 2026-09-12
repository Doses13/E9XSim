using System;
using System.Collections.Generic;
using System.Text;

namespace E9XSim.mainApp
{
    public class SimulationClock
    {
        public TimeSpan Time { get; private set; }

        public bool IsRunning { get; private set; }

        public void Play()
        {
            IsRunning = true;
        }

        public void Pause()
        {
            IsRunning = false;
        }
        
        public void Step(TimeSpan timeStep)
        {
            Time += timeStep;   
        }

        public void Reset()
        {
            Time = TimeSpan.Zero;
            IsRunning = false;
        }

    }
}

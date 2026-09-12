using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;
using System.Windows.Threading;

namespace E9XSim.mainApp
{
    public sealed class SimulationRunner
    {
        private readonly SimulationEngine _engine;

        private readonly DispatcherTimer _timer;

        private readonly Stopwatch _stopwatch = new();

        private TimeSpan _lastWallTime;
        private TimeSpan _accumulator;

        public TimeSpan FixedStep { get; } = TimeSpan.FromMilliseconds(1);

        public double Speed { get; set; } = 1.0;

        public SimulationRunner(SimulationEngine engine)
        {
            _engine = engine;

            _timer = new DispatcherTimer
            {
                Interval = TimeSpan.FromMilliseconds(10)
            };

            _timer.Tick += OnTimerTick;

            _stopwatch.Start();
            _lastWallTime = _stopwatch.Elapsed;

            _timer.Start();
        }

        private void OnTimerTick(object? sender, EventArgs e)
        {
            TimeSpan now = _stopwatch.Elapsed;
            TimeSpan wallElapsed = now - _lastWallTime;

            _lastWallTime = now;

            if (!_engine.Clock.IsRunning)
            {
                return;
            }

            _accumulator += wallElapsed * Speed;

            while (_accumulator >= FixedStep)
            {
                _engine.Step(FixedStep);
                _accumulator -= FixedStep;
            }
        }

        public void Play()
        {
            _lastWallTime = _stopwatch.Elapsed;
            _engine.Clock.Play();
        }

        public void Pause()
        {
            _engine.Clock.Pause();
            _accumulator = TimeSpan.Zero;
        }

        public void Step()
        {
            if (_engine.Clock.IsRunning)
            {
                return;
            }

            _engine.Step(FixedStep);
        }
    }
}

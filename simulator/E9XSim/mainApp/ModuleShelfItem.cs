using E9XSim.modules;
using System;
using System.Collections.Generic;
using System.Text;
using System.Windows;

namespace E9XSim.mainApp
{
    public sealed class ModuleShelfItem
    {
        private Window? _window;

        public ISimModule Module { get; }

        public string Name => Module.Name;

        public string Type {  get; }

        private readonly Func<Window> _windowFactory;

        public ModuleShelfItem(
            ISimModule module,
            string type,
            Func<Window> windowFactory)
        {
            Module = module;
            Type = type;
            _windowFactory = windowFactory;
        }

        public void OpenWindow()
        {
            if (_window != null)
            {
                if (_window.WindowState == WindowState.Minimized)
                {
                    _window.WindowState = WindowState.Normal;
                }
            }

            _window = _windowFactory();

            _window.Closed += (_, _) =>
            {
                _window = null;
            };

            _window.Show();
        }

    }
}

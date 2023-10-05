using Microsoft.PowerShell;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace tpsh
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private readonly Runspace runspace;

        public MainWindow()
        {
            InitializeComponent();

            // Create a default initial session state and set the execution policy.
            InitialSessionState initialSessionState = InitialSessionState.CreateDefault();
            initialSessionState.ExecutionPolicy = ExecutionPolicy.Unrestricted;

            runspace = RunspaceFactory.CreateRunspace(initialSessionState);
            runspace.Open();
            Closing += DisposeAll;
        }

        private void DisposeAll(object? sender, System.ComponentModel.CancelEventArgs e)
        {
            runspace.Dispose();
        }

        private async Task<string> RunScript()
        {
            // create a new hosted PowerShell instance using the default runspace.
            // wrap in a using statement to ensure resources are cleaned up.
            try
            {
                using (PowerShell ps = PowerShell.Create(runspace))
                {
                    // specify the script code to run.
                    ps.AddScript("get-ddate");

                    // execute the script and await the result.
                    var pipelineObjects = await ps.InvokeAsync().ConfigureAwait(false);
                    if (ps.HadErrors)
                    {
                        return ps.Streams.Error.ToArray<ErrorRecord>()[0].Exception.Message;
                    }

                    string result = "";
                    // print the resulting pipeline objects to the console.
                    foreach (var item in pipelineObjects)
                    {
                        result += item.Properties["Formatted"].Value;
                    }
                    return result;
                }
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }

        private async void Button_Click(object sender, RoutedEventArgs e)
        {
            tblk.Text = "Running...";
	    await Task.Delay(1000);
            tblk.Text = await RunScript();
        }

    }
}

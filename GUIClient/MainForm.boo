namespace GUIClient

import System
import System.Collections
import System.Drawing
import System.Windows.Forms

partial class MainForm:
	public def constructor():
		// The InitializeComponent() call is required for Windows Forms designer support.
		InitializeComponent()
		// TODO: Add constructor code after the InitializeComponent() call.

[STAThread]
public def Main(argv as (string)) as void:
	Application.EnableVisualStyles()
	Application.SetCompatibleTextRenderingDefault(false)
	Application.Run(MainForm())


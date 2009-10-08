namespace GUIClient

partial class MainForm(System.Windows.Forms.Form):
	private components as System.ComponentModel.IContainer = null
	
	protected override def Dispose(disposing as bool) as void:
		if disposing:
			if components is not null:
				components.Dispose()
		super(disposing)
	
	// This method is required for Windows Forms designer support.
	// Do not change the method contents inside the source code editor. The Forms designer might
	// not be able to load this method if it was changed manually.
	private def InitializeComponent():
		self.tabControl1 = System.Windows.Forms.TabControl()
		self.SettingsTab = System.Windows.Forms.TabPage()
		self.checkBox1 = System.Windows.Forms.CheckBox()
		self.button1 = System.Windows.Forms.Button()
		self.QueryTab = System.Windows.Forms.TabPage()
		self.checkBox2 = System.Windows.Forms.CheckBox()
		self.progressBar1 = System.Windows.Forms.ProgressBar()
		self.tabControl1.SuspendLayout()
		self.SettingsTab.SuspendLayout()
		self.SuspendLayout()
		# 
		# tabControl1
		# 
		self.tabControl1.Controls.Add(self.SettingsTab)
		self.tabControl1.Controls.Add(self.QueryTab)
		self.tabControl1.Location = System.Drawing.Point(3, 3)
		self.tabControl1.Name = "tabControl1"
		self.tabControl1.SelectedIndex = 0
		self.tabControl1.Size = System.Drawing.Size(569, 463)
		self.tabControl1.TabIndex = 0
		# 
		# SettingsTab
		# 
		self.SettingsTab.Controls.Add(self.progressBar1)
		self.SettingsTab.Controls.Add(self.checkBox2)
		self.SettingsTab.Controls.Add(self.checkBox1)
		self.SettingsTab.Controls.Add(self.button1)
		self.SettingsTab.Location = System.Drawing.Point(4, 22)
		self.SettingsTab.Name = "SettingsTab"
		self.SettingsTab.Padding = System.Windows.Forms.Padding(3)
		self.SettingsTab.Size = System.Drawing.Size(561, 437)
		self.SettingsTab.TabIndex = 0
		self.SettingsTab.Text = "Settings"
		self.SettingsTab.UseVisualStyleBackColor = true
		# 
		# checkBox1
		# 
		self.checkBox1.Location = System.Drawing.Point(7, 7)
		self.checkBox1.Name = "checkBox1"
		self.checkBox1.Size = System.Drawing.Size(202, 24)
		self.checkBox1.TabIndex = 1
		self.checkBox1.Text = "Enable Porter Stemming"
		self.checkBox1.UseVisualStyleBackColor = true
		# 
		# button1
		# 
		self.button1.Location = System.Drawing.Point(461, 401)
		self.button1.Name = "button1"
		self.button1.Size = System.Drawing.Size(94, 30)
		self.button1.TabIndex = 0
		self.button1.Text = "Build index"
		self.button1.UseVisualStyleBackColor = true
		# 
		# QueryTab
		# 
		self.QueryTab.Location = System.Drawing.Point(4, 22)
		self.QueryTab.Name = "QueryTab"
		self.QueryTab.Padding = System.Windows.Forms.Padding(3)
		self.QueryTab.Size = System.Drawing.Size(561, 437)
		self.QueryTab.TabIndex = 1
		self.QueryTab.Text = "Query"
		self.QueryTab.UseVisualStyleBackColor = true
		# 
		# checkBox2
		# 
		self.checkBox2.Location = System.Drawing.Point(7, 37)
		self.checkBox2.Name = "checkBox2"
		self.checkBox2.Size = System.Drawing.Size(202, 24)
		self.checkBox2.TabIndex = 1
		self.checkBox2.Text = "Enable Stopword Elimination"
		self.checkBox2.UseVisualStyleBackColor = true
		# 
		# progressBar1
		# 
		self.progressBar1.Location = System.Drawing.Point(7, 401)
		self.progressBar1.Name = "progressBar1"
		self.progressBar1.Size = System.Drawing.Size(448, 30)
		self.progressBar1.TabIndex = 2
		# 
		# MainForm
		# 
		self.AutoScaleDimensions = System.Drawing.SizeF(6, 13)
		self.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
		self.ClientSize = System.Drawing.Size(584, 478)
		self.Controls.Add(self.tabControl1)
		self.Font = System.Drawing.Font("Segoe UI", 8.25, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, cast(System.Byte,0))
		self.Name = "MainForm"
		self.Text = "MainForm"
		self.tabControl1.ResumeLayout(false)
		self.SettingsTab.ResumeLayout(false)
		self.ResumeLayout(false)
	private progressBar1 as System.Windows.Forms.ProgressBar
	private checkBox2 as System.Windows.Forms.CheckBox
	private button1 as System.Windows.Forms.Button
	private checkBox1 as System.Windows.Forms.CheckBox
	private QueryTab as System.Windows.Forms.TabPage
	private SettingsTab as System.Windows.Forms.TabPage
	private tabControl1 as System.Windows.Forms.TabControl


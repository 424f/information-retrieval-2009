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
		self.MainTabControl = System.Windows.Forms.TabControl()
		self.SettingsTab = System.Windows.Forms.TabPage()
		self.BuildProgress = System.Windows.Forms.ProgressBar()
		self.EnableStopwordElimination = System.Windows.Forms.CheckBox()
		self.EnablePorterStemming = System.Windows.Forms.CheckBox()
		self.BuildIndexButton = System.Windows.Forms.Button()
		self.QueryTab = System.Windows.Forms.TabPage()
		self.SearchResultsText = System.Windows.Forms.TextBox()
		self.SearchButton = System.Windows.Forms.Button()
		self.SearchText = System.Windows.Forms.TextBox()
		self.StatsTab = System.Windows.Forms.TabPage()
		self.StatsText = System.Windows.Forms.TextBox()
		self.MainTabControl.SuspendLayout()
		self.SettingsTab.SuspendLayout()
		self.QueryTab.SuspendLayout()
		self.StatsTab.SuspendLayout()
		self.SuspendLayout()
		# 
		# MainTabControl
		# 
		self.MainTabControl.Controls.Add(self.SettingsTab)
		self.MainTabControl.Controls.Add(self.QueryTab)
		self.MainTabControl.Controls.Add(self.StatsTab)
		self.MainTabControl.Location = System.Drawing.Point(3, 3)
		self.MainTabControl.Name = "MainTabControl"
		self.MainTabControl.SelectedIndex = 0
		self.MainTabControl.Size = System.Drawing.Size(569, 463)
		self.MainTabControl.TabIndex = 0
		# 
		# SettingsTab
		# 
		self.SettingsTab.Controls.Add(self.BuildProgress)
		self.SettingsTab.Controls.Add(self.EnableStopwordElimination)
		self.SettingsTab.Controls.Add(self.EnablePorterStemming)
		self.SettingsTab.Controls.Add(self.BuildIndexButton)
		self.SettingsTab.Location = System.Drawing.Point(4, 22)
		self.SettingsTab.Name = "SettingsTab"
		self.SettingsTab.Padding = System.Windows.Forms.Padding(3)
		self.SettingsTab.Size = System.Drawing.Size(561, 437)
		self.SettingsTab.TabIndex = 0
		self.SettingsTab.Text = "Settings"
		self.SettingsTab.UseVisualStyleBackColor = true
		# 
		# BuildProgress
		# 
		self.BuildProgress.Location = System.Drawing.Point(7, 401)
		self.BuildProgress.Name = "BuildProgress"
		self.BuildProgress.Size = System.Drawing.Size(448, 30)
		self.BuildProgress.TabIndex = 2
		# 
		# EnableStopwordElimination
		# 
		self.EnableStopwordElimination.Location = System.Drawing.Point(7, 37)
		self.EnableStopwordElimination.Name = "EnableStopwordElimination"
		self.EnableStopwordElimination.Size = System.Drawing.Size(202, 24)
		self.EnableStopwordElimination.TabIndex = 1
		self.EnableStopwordElimination.Text = "Enable Stopword Elimination"
		self.EnableStopwordElimination.UseVisualStyleBackColor = true
		# 
		# EnablePorterStemming
		# 
		self.EnablePorterStemming.Location = System.Drawing.Point(7, 7)
		self.EnablePorterStemming.Name = "EnablePorterStemming"
		self.EnablePorterStemming.Size = System.Drawing.Size(202, 24)
		self.EnablePorterStemming.TabIndex = 1
		self.EnablePorterStemming.Text = "Enable Porter Stemming"
		self.EnablePorterStemming.UseVisualStyleBackColor = true
		# 
		# BuildIndexButton
		# 
		self.BuildIndexButton.Location = System.Drawing.Point(461, 401)
		self.BuildIndexButton.Name = "BuildIndexButton"
		self.BuildIndexButton.Size = System.Drawing.Size(94, 30)
		self.BuildIndexButton.TabIndex = 0
		self.BuildIndexButton.Text = "Build index"
		self.BuildIndexButton.UseVisualStyleBackColor = true
		self.BuildIndexButton.Click += self.BuildIndexButtonClick as System.EventHandler
		# 
		# QueryTab
		# 
		self.QueryTab.Controls.Add(self.SearchResultsText)
		self.QueryTab.Controls.Add(self.SearchButton)
		self.QueryTab.Controls.Add(self.SearchText)
		self.QueryTab.Location = System.Drawing.Point(4, 22)
		self.QueryTab.Name = "QueryTab"
		self.QueryTab.Padding = System.Windows.Forms.Padding(3)
		self.QueryTab.Size = System.Drawing.Size(561, 437)
		self.QueryTab.TabIndex = 1
		self.QueryTab.Text = "Query"
		self.QueryTab.UseVisualStyleBackColor = true
		# 
		# SearchResultsText
		# 
		self.SearchResultsText.Location = System.Drawing.Point(7, 35)
		self.SearchResultsText.Multiline = true
		self.SearchResultsText.Name = "SearchResultsText"
		self.SearchResultsText.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
		self.SearchResultsText.Size = System.Drawing.Size(548, 399)
		self.SearchResultsText.TabIndex = 2
		# 
		# SearchButton
		# 
		self.SearchButton.Location = System.Drawing.Point(461, 5)
		self.SearchButton.Name = "SearchButton"
		self.SearchButton.Size = System.Drawing.Size(94, 23)
		self.SearchButton.TabIndex = 1
		self.SearchButton.Text = "Search"
		self.SearchButton.UseVisualStyleBackColor = true
		self.SearchButton.Click += self.SearchButtonClick as System.EventHandler
		# 
		# SearchText
		# 
		self.SearchText.Location = System.Drawing.Point(7, 7)
		self.SearchText.Name = "SearchText"
		self.SearchText.Size = System.Drawing.Size(447, 22)
		self.SearchText.TabIndex = 0
		self.SearchText.KeyDown += self.SearchTextKeyDown as System.Windows.Forms.KeyEventHandler
		# 
		# StatsTab
		# 
		self.StatsTab.Controls.Add(self.StatsText)
		self.StatsTab.Location = System.Drawing.Point(4, 22)
		self.StatsTab.Name = "StatsTab"
		self.StatsTab.Padding = System.Windows.Forms.Padding(3)
		self.StatsTab.Size = System.Drawing.Size(561, 437)
		self.StatsTab.TabIndex = 2
		self.StatsTab.Text = "Stats"
		self.StatsTab.UseVisualStyleBackColor = true
		# 
		# StatsText
		# 
		self.StatsText.Location = System.Drawing.Point(7, 7)
		self.StatsText.Multiline = true
		self.StatsText.Name = "StatsText"
		self.StatsText.Size = System.Drawing.Size(548, 424)
		self.StatsText.TabIndex = 0
		# 
		# MainForm
		# 
		self.AutoScaleDimensions = System.Drawing.SizeF(6, 13)
		self.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
		self.ClientSize = System.Drawing.Size(584, 478)
		self.Controls.Add(self.MainTabControl)
		self.Font = System.Drawing.Font("Segoe UI", 8.25, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, cast(System.Byte,0))
		self.Name = "MainForm"
		self.Text = "Information Retrieval"
		self.MainTabControl.ResumeLayout(false)
		self.SettingsTab.ResumeLayout(false)
		self.QueryTab.ResumeLayout(false)
		self.QueryTab.PerformLayout()
		self.StatsTab.ResumeLayout(false)
		self.StatsTab.PerformLayout()
		self.ResumeLayout(false)
	private StatsText as System.Windows.Forms.TextBox
	private StatsTab as System.Windows.Forms.TabPage
	private MainTabControl as System.Windows.Forms.TabControl
	private BuildProgress as System.Windows.Forms.ProgressBar
	private SearchResultsText as System.Windows.Forms.TextBox
	private SearchText as System.Windows.Forms.TextBox
	private SearchButton as System.Windows.Forms.Button
	private EnableStopwordElimination as System.Windows.Forms.CheckBox
	private EnablePorterStemming as System.Windows.Forms.CheckBox
	private BuildIndexButton as System.Windows.Forms.Button
	private QueryTab as System.Windows.Forms.TabPage
	private SettingsTab as System.Windows.Forms.TabPage
	
	private def SearchTextKeyDown(sender as object, e as System.Windows.Forms.KeyEventArgs):
		if e.KeyCode == System.Windows.Forms.Keys.Return:
			SearchButtonClick(sender, null)
			e.SuppressKeyPress = true


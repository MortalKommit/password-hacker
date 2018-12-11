Add-Type -AssemblyName System.Windows.Forms

$Form = New-Object System.Windows.Forms.Form

$Form.Text = "Cleaning Options"
$Form.Width = 240
$Form.Height = 480
$Form.AutoSize = $True
$Form.AutoSizeMode = "GrowAndShrink"
$Form.MaximizeBox = $False
$Form.WindowState = "Normal"
# CenterScreen, Manual, WindowsDefaultLocation, WindowsDefaultBounds, CenterParent
$Form.StartPosition = "CenterScreen"
#Color = GhostWhite
$Form.BackColor = "#FFF8F8FF"

$OSoptionslist = 'Applications Jump List','Windows Recent Items','Automatic Destinations','File Explorer Search',`
               'File Explorer Typed Paths','Run Command History','VLC Player History','Windows Media Player History', `
               'Temporary Internet Files','Cookies and Cache','Browsing History','Form Data','Passwords'


$ListView = New-Object System.Windows.Forms.ListView
$Form.Controls.Add($ListView) | Out-Null
$ListView.Items.AddRange($optionslist) | Out-Null
$ListView.Groups.Add("OS Clear Options") | Out-Null
$ListView.Groups.Add("Media Clear Options") | Out-Null
$ListView.Groups.Add("Browser Clear Options") | Out-Null
for($i = 0; $i -lt $ListView.Items.Count; $i++){
    if($i -le 5){
        $ListView.Items[$i].Group = $ListView.Groups[0]
    }
    
    else{
        if($i -le 7){
            $ListView.Items[$i].Group = $ListView.Groups[1]
        }
        else{
            $ListView.Items[$i].Group = $ListView.Groups[2]
        }
    }
}

$ListView.Width = 320
$ListView.Height = 160
$ListView.AutoSize = $True
$Form.ShowDialog() | Out-Null
<#
$CheckBox = New-Object System.Windows.Forms.CheckedListBox
$Checkbox.Items.AddRange($optionslist)

#Only Click once to check a box
$Checkbox.CheckOnClick = $true 
$Checkbox.SetItemChecked(1,$True)
$Checkbox.AutoSize = $True
$Form.Controls.Add($CheckBox)
$Form.ShowDialog() | Out-Null

$Checkbox.CheckedItems
#>

Add-Type -AssemblyName PresentationFramework, PresentationCore

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="Smile Guy"
        WindowStyle="None"
        WindowState="Maximized"
        ResizeMode="NoResize"
        Background="Black"
        Foreground="White"
        FontFamily="Consolas"
        FontSize="16"
        Topmost="True"
        ShowInTaskbar="False">
    <Grid Margin="20">
        <StackPanel VerticalAlignment="Center" HorizontalAlignment="Center">
            <TextBlock Name="Face" Text=":)" FontSize="30" HorizontalAlignment="Center" Margin="0,0,0,10"/>
            <TextBlock Text="Type (try typing hi!):" FontSize="18" HorizontalAlignment="Center" Margin="0,0,0,10"/>
            <TextBox Name="InputBox" FontSize="16" Width="300" Background="#222" Foreground="White"/>
        </StackPanel>
    </Grid>
</Window>
"@

# Load XAML
$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

# Get UI elements
$face = $window.FindName("Face")
$inputBox = $window.FindName("InputBox")

# Memory file path (same folder as script)
$memoryFile = "$PSScriptRoot\SmileGuyMemory.json"

function LoadMemory {
    if (Test-Path $memoryFile) {
        try {
            $json = Get-Content $memoryFile -Raw
            $obj = $json | ConvertFrom-Json
            if ($null -eq $obj) { return @{} }
            $ht = @{}
            foreach ($prop in $obj.PSObject.Properties) {
                $ht[$prop.Name] = $prop.Value
            }
            return $ht
        }
        catch {
            return @{}
        }
    } else {
        return @{}
    }
}

function SaveMemory {
    param($mem)
    $mem | ConvertTo-Json -Depth 3 | Set-Content -Path $memoryFile -Encoding UTF8
}

$global:memory = LoadMemory

# Your fixed rejection for "Lone"
function IsNameRejected {
    param($name)
    return ($name -ieq "lone")
}

# Local LLM API call function
function Get-ChatCompletion {
    param(
        [string]$userMessage
    )

    $uri = "http://localhost:1234/v1/chat/completions"

    $body = @{
        model = "gemma-3-12b"  # change if needed
        messages = @(
            @{ role = "system"; content = "You are Lil' Guy, a friendly and cute assistant." },
            @{ role = "user"; content = $userMessage }
        )
    } | ConvertTo-Json -Depth 5

    try {
        $response = Invoke-RestMethod -Uri $uri -Method Post -Body $body -ContentType "application/json"
        # Assumes response.choices[0].message.content style (OpenAI-like)
        return $response.choices[0].message.content
    }
    catch {
        return "Error contacting AI server: $_"
    }
}

# Handle user input
$inputBox.Add_KeyDown({
    if ($_.Key -eq 'Return') {
        $text = $inputBox.Text.Trim()
        $inputBox.Text = ""

        if ($text -match "^my name is (.+)$") {
            $inputName = $matches[1].Trim()

            if (IsNameRejected $inputName) {
                $face.FontSize = 25
                $face.Text = "Sorry, you are not allowed to use that name."
                return
            }

            $global:memory["username"] = $inputName
            SaveMemory $global:memory
            $face.FontSize = 25
            $face.Text = "Nice to meet you, $inputName! I'll remember you! :D"
            return
        }

        if ($text.ToLower() -eq "whats my name") {
            if ($global:memory.ContainsKey("username")) {
                $face.FontSize = 25
                $face.Text = "Your name is $($global:memory["username"])! :3"
            }
            else {
                $face.FontSize = 25
                $face.Text = "I don't know your name yet! Tell me by typing 'my name is ...'"
            }
            return
        }

        if ($text.ToLower() -eq "exit") {
            $face.FontSize = 25
            $face.Text = "Bye! See you soon! :)"
            Start-Sleep -Seconds 1
            $window.Close()
            [System.Windows.Threading.Dispatcher]::ExitAllFrames()
            return
        }

        # Call the AI API for other inputs
        $aiResponse = Get-ChatCompletion -userMessage $text

        if ($aiResponse) {
            $face.FontSize = 25
            $face.Text = $aiResponse
        }
        else {
            $face.FontSize = 30
            $face.Text = "I didn't get a response... sorry! :("
        }
    }
})

# Exit with Escape key
$window.Add_KeyDown({
    if ($_.Key -eq 'Escape') {
        $window.Close()
        [System.Windows.Threading.Dispatcher]::ExitAllFrames()
    }
})

# Focus input on load
$window.Add_SourceInitialized({
    $inputBox.Focus() | Out-Null
})

# Launch the app
$window.Show()
[System.Windows.Threading.Dispatcher]::Run()

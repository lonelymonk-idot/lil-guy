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
            <TextBlock Name="Face" Text=":)" FontSize="130" HorizontalAlignment="Center" Margin="0,0,0,10"/>
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

# Emoticon responses
$responses = @{
    "hi!" = ":)"
    "i love you" = ":3"
    "i hate you" = ">:("
    "youre dumb" = ":/"
    "stupid" = ">:("
    "why do you exist" = ">_<"
    "are you actually sentient" = "^_^"
    "recommend a movie" = ":D - Creator I recommend 'The Matrix' (Guess what it's about!)"
    "tell me a joke" = ":D - Creator (I talk for lil' guy): Why did the computer go to therapy? It had too many bytes!"
    "what is your purpose" = ">-<"
    "i am going to kill you" = ">:( - Creator: Not if I do it first."
    "i am going to kill myself" = ":( - Creator: Please don't, you are loved by many!"
    "recommend a card game" = ":D - Creator: I recommend 'UNO!'! It's a classic!"
    "youtube" = ":D - lonelymonk_GT "
    "discord" = ":D - https://discord.gg/pPZdft8p4b for my discord server! (secret dev one: https://discord.gg/FJMmTAAWPw)"
    "exit" = ":p"
}

# Handle user input
$inputBox.Add_KeyDown({
    if ($_.Key -eq 'Return') {
        $text = $inputBox.Text.ToLower().Trim()
        $inputBox.Text = ""

        if ($text -eq "exit") {
            $window.Close()
            [System.Windows.Threading.Dispatcher]::ExitAllFrames()
            return
        }

        if ($responses.ContainsKey($text)) {
            $response = $responses[$text]

            # Check if it should use small font
            if ($response -like "*- Creator*" -or $response.Length -gt 5) {
                $face.FontSize = 25
            } else {
                $face.FontSize = 250
            }

            $face.Text = $response
        } else {
            $face.FontSize = 250
            $face.Text = ":p"
        }
    }
})


# Exit with Escape
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

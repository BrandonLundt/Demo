Function Sing{
    process{
        Add-Type -AssemblyName System.speech
        $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer

        $speak.Rate = 10
        $speak.Speak('One, two, three, four:')
        $speak.Speak('Grandma got run over by a reindeer')
        $speak.Speak('Walking home from our house Christmas eve')
        $speak.Speak('You can say theres no such thing as Santa')
        $speak.Speak('But as for me and Grandpa, we believe')
    }#process
}#Function
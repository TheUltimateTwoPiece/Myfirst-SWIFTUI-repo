//
//  ContentView.swift
//  lesson6
//
//  Created by Kakarla Hemanth Reddy on 31/8/26.
//
// abel was here
// all this by elijah btw
import SwiftUI

struct ContentView: View {
    @State private var inputPassword = ""
    @State private var feedbackMessage = "Enter a password to begin the tourturess."
    @State private var attemptCount = 0
    
    let roasts = [
        "Absolutely not. That thing has the security of a cardboard box.",
        "You had one job. Somehow the password still failed.",
        "Bold strategy. Unfortunately, it is also terrible.",
        "The security system has witnessed enough.",
        "That password couldn't guard a sandwich.",
        "Somewhere, a hacker just gained confidence.",
        "This has the energy of a password made at 3 AM.",
        "Not gonna lie, I've seen stronger Wi-Fi names.",
        "You really looked at the keyboard and chose THAT?",
        "That's not security. That's decoration.",
        "The password checker just sighed.",
        "Congratulations, you've invented a new way to be predictable.",
        "Even random guessing would feel unfair.",
        "This password has absolutely no gusto.",
        "I would explain why it's bad, but the password already did.",
        "Security level: unlocked before you even finished typing.",
        "That belongs in the 'never use this again' folder.",
        "Your password is built like a house made of paper.",
        "The firewall is requesting better material.",
        "This isn't getting past anything except maybe a loading screen.",
        "You could've chosen literally anything. Impressive.",
        "That password has the survival instincts of a goldfish.",
        "The security algorithm has officially lost faith.",
        "This is what happens when confidence exceeds ability.",
        "Your password just got academically expelled from cybersecurity.",
        "That string of characters needs adult supervision.",
        "I ran the numbers. The numbers are disappointed.",
        "This password has more problems than characters.",
        "The database looked at this and said 'be serious.'",
        "Some passwords are forgettable. Yours is unforgettable for all the wrong reasons.",
        "This could be guessed by someone who isn't even trying.",
        "The security check wasn't even a challenge.",
        "That password is running on pure optimism.",
        "I've seen stronger locks on a diary.",
        "This is less 'secure' and more 'good luck, I guess.'",
        "Your password has entered the comedy department.",
        "The computer has decided you need another attempt.",
        "That was certainly a password-shaped decision.",
        "No encryption can save that personality.",
        "This password is fighting against itself.",
        "You didn't make a secure password. You made a suggestion.",
        "The security bar saw this and stayed completely still.",
        "That password needs a redemption arc.",
        "Not terrible. Just impressively terrible.",
        "The system isn't angry. It's just disappointed.",
        "This password has approximately zero defensive capabilities.",
        "You brought a pool noodle to a cybersecurity fight.",
        "That thing wouldn't protect a Roblox door.",
        "The password generator is somewhere shaking its head.",
        "I have bad news: your password is cooked.",
        "This password is so predictable it could've written itself.",
        "Security status: please try literally harder.",
        "The login screen deserves better than this.",
        "That password just lost a fight against basic common sense.",
        "I'm starting to think the password is working against you.",
        "This is less cybersecurity and more cyber-comedy.",
        "You know what? Let's pretend you never typed that.",
        "The system has reviewed your submission and respectfully declined.",
        "That password needs to go back to the lab.",
        "Somewhere between 'password' and 'please hack me' lies this.",
        "You've achieved a truly impressive level of insecurity.",
        "The security team would like a word.",
        "This password has the structural integrity of wet tissue.",
        "I can't roast this any harder. It already did that to itself.",
        "Your password just got humbled by an error message.",
        "At this point, the password is the vulnerability.",
        "The only thing protected here is the hacker's free time.",
        "That was not the secret combination. That was a public announcement.",
        "You really pressed submit after that. Respectfully: why?",
        "This password has been denied entry to the security department.",
        "Even the 'forgot password' button feels safer.",
        "Final rating: spectacularly mid.",
        "Please create something that doesn't look like your first attempt.",
        "This password has officially been placed on the watchlist.",
        "The system has spoken. It wants better.",
        "Maybe don't let this password anywhere near important information.",
        "That's enough cybersecurity for today. Go again.",
        "Your password just got ratio'd by the validation system.",
        "Honestly? The attempt was more secure than the password.",
        "This is a password only a mother could love.",
        "I've seen CAPTCHA tests with more personality.",
        "The keyboard deserves an apology.",
        "Your password has failed the vibe check AND the security check.",
        "Somewhere, a cybersecurity teacher just felt a disturbance.",
        "This password is giving 'I clicked generate and panicked.'",
        "The security meter didn't move. It just gave up.",
        "You have successfully created something that should never be reused.",
        "That password isn't guarding the account. It's snitching on it.",
        "Absolutely magnificent. Magnificently insecure.",
        "I'm not saying it's bad, but the error message wrote itself.",
        "This password has been politely escorted away from the login screen."
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            Text("uh type something")
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
            
            Text("Attempt #\(attemptCount)")
                .font(.caption)
                .foregroundColor(.secondary)
                .bold()
            
            Text(feedbackMessage)
                .font(.body)
                .foregroundColor(.red)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .frame(height: 60)
            
            SecureField("Enter password...", text: $inputPassword)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Button(action: {
                if !inputPassword.isEmpty {
                    feedbackMessage = roasts[attemptCount % roasts.count]
                    attemptCount += 1
                    inputPassword = ""
                }
            }) {
                Text("lets check if ur password is good or plain trash")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(inputPassword.isEmpty ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(inputPassword.isEmpty)
            .padding(.horizontal)
        }
        .padding()
    }
}


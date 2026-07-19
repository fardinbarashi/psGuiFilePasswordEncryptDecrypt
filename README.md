# FilePasswordEncryptDecrypt

![](https://raw.githubusercontent.com/fardinbarashi/psGuiFilePasswordEncryptDecrypt/refs/heads/main/githubRepoContentDeleteIfYouWant/IMG/passwordlogo2.png)

**Note:** Encrypted passwords can only be decrypted by the same user and on the same system they were encrypted on.

## FilePasswordEncryptDecrypt (PowerShell GUI)
![](https://raw.githubusercontent.com/fardinbarashi/psGuiFilePasswordEncryptDecrypt/refs/heads/main/githubRepoContentDeleteIfYouWant/IMG/1.jpg)
### Overview
**FilePasswordEncryptDecrypt** 
```
is a simple, GUI-based PowerShell tool that allows you to securely encrypt and decrypt passwords. 
It uses the current user context, meaning only the user who encrypted the password can later decrypt it
ensuring local security without the need for third-party tools. Uses WPF

Features
- Encrypt any password and save it to a file
- Decrypt passwords by selecting the encrypted file
- Integrated file explorer for selecting output paths
- Transcript logging for auditing and troubleshooting

System Requirements

| Requirement              | Version                  |
|--------------------------|--------------------------|
| PowerShell Version       | 5.1 or later  |

How to Use
Encrypt a Password
1. **Run the script** (double-click or via PowerShell).
2. Enter your password in the top textbox.
3. Specify a file path where you want to save the encrypted password, or use the built-in **"Open FileExplorer"** button.
4. Click **"Save Encrypt Password"**.
5. Done! Your password is now encrypted and saved to a file (e.g., `C:\Temp\Password.txt`).

Decrypt a Password
1. In the menu bar, go to **Decrypt File → Select-File to Decrypt**.
2. Browse and select the file containing your encrypted password.
3. The decrypted password will appear in the status bar at the bottom of the form.


Security Notes
- This script uses PowerShell's built-in secure string methods.
- Encryption is user- and machine-specific.

```

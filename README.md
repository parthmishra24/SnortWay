# Wayback Machine Scraper & Confidential Data Detector

This Bash script automates the process of extracting archived URLs from the Wayback Machine for a given domain, filtering them for potentially sensitive files, and scanning downloaded PDFs for confidential information.

## Features

- **Extract URLs** from the Wayback Machine for any given domain.
- **Filter URLs** containing sensitive file extensions (e.g., `.pdf`, `.docx`, `.sql`, `.json`, etc.).
- **Interrupt Handling**: Press `Ctrl+C` once to process collected data, twice to exit.
- **Confidential Data Detection** in PDFs (e.g., "confidential", "internal use only", "bank statement", etc.).
- **Logs** filtered URLs and confidential URLs separately.

## Installation

Ensure you have the required dependencies installed:

```bash
sudo apt install curl pdftotext grep uro
```

For macOS:

```bash
brew install curl poppler grep uro
```

## Usage

Run the script and enter the domain to analyze:

```bash
./SnortInfoDis.sh
```

### Example Workflow

1. The script prompts for a domain (e.g., `example.com`).
2. It fetches archived URLs from the Wayback Machine.
3. If you press `Ctrl+C`, it stops downloading and begins processing.
4. The script filters URLs containing sensitive file types and saves them in `<domain>_filtered.txt`.
5. It scans PDFs for confidential keywords and logs them in `<domain>_confidential.txt`.
6. If no confidential data is found, it prints `No confidential data found.`

## Output Files

- ``: Contains URLs of potentially sensitive files.
- ``: Contains URLs of PDFs that contain confidential data.

## Reference

This tool utilizes a methodology inspired by **@coffinxp**, who provided the core command structure for filtering and analyzing confidential data in PDFs. Please refer to his writeup for the commands used in the tool.

For a detailed explanation of the commands used in this tool, check out this article by coffinxp:
https://infosecwriteups.com/unlock-the-full-potential-of-the-wayback-machine-for-bug-bounty-8b6f57e2637d

## License

This project is open-source under the MIT License.

## Disclaimer

This script is for **educational and research purposes only**. Do not use it for unauthorized activities.

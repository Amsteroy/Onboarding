pip install pyinstaller
pyinstaller --onefile main.py
delete ".\main.exe" /q
copy ".\dist\main.exe" "./"
rmdir /s /q ".\dist"

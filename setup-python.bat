@echo off
REM Windows Python セットアップバッチファイル
REM このファイルはPowerShellスクリプトを実行するためのランチャーです

echo ========================================
echo Windows Python セットアップ
echo ========================================
echo.

REM 管理者権限チェック
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [エラー] このスクリプトは管理者権限で実行する必要があります。
    echo.
    echo 右クリックして「管理者として実行」を選択してください。
    echo.
    pause
    exit /b 1
)

echo 管理者権限を確認しました。
echo.
echo PowerShellスクリプトを実行します...
echo.

REM PowerShellスクリプトを実行
PowerShell -ExecutionPolicy Bypass -File "%~dp0setup-python-windows.ps1"

if %errorLevel% equ 0 (
    echo.
    echo ========================================
    echo セットアップが完了しました
    echo ========================================
) else (
    echo.
    echo ========================================
    echo セットアップ中にエラーが発生しました
    echo ========================================
)

echo.
pause

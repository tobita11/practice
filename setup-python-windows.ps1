# Windows Python セットアップスクリプト
# インストール先: E:\python

param(
    [string]$PythonVersion = "3.12.1",
    [string]$InstallPath = "E:\python"
)

# 管理者権限チェック
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "このスクリプトは管理者権限で実行する必要があります。" -ForegroundColor Red
    Write-Host "PowerShellを管理者として起動してから再実行してください。" -ForegroundColor Yellow
    exit 1
}

Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host "Windows Python セットアップ" -ForegroundColor Cyan
Write-Host "インストール先: $InstallPath" -ForegroundColor Cyan
Write-Host "Pythonバージョン: $PythonVersion" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan

# インストールディレクトリの作成
if (-not (Test-Path $InstallPath)) {
    Write-Host "`nインストールディレクトリを作成中: $InstallPath" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $InstallPath -Force | Out-Null
}

# 一時ディレクトリの作成
$tempDir = Join-Path $env:TEMP "python_installer"
if (-not (Test-Path $tempDir)) {
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
}

# Pythonインストーラーのダウンロード
$installerUrl = "https://www.python.org/ftp/python/$PythonVersion/python-$PythonVersion-amd64.exe"
$installerPath = Join-Path $tempDir "python-installer.exe"

Write-Host "`nPythonインストーラーをダウンロード中..." -ForegroundColor Yellow
Write-Host "URL: $installerUrl"

try {
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath -UseBasicParsing
    Write-Host "ダウンロード完了" -ForegroundColor Green
} catch {
    Write-Host "ダウンロードに失敗しました: $_" -ForegroundColor Red
    exit 1
}

# Pythonのインストール
Write-Host "`nPythonをインストール中..." -ForegroundColor Yellow
Write-Host "インストール先: $InstallPath"

# サイレントインストールのオプション
# - InstallAllUsers=0: 現在のユーザーのみ
# - TargetDir: インストール先ディレクトリ
# - PrependPath=1: 環境変数PATHに追加
# - Include_test=0: テストスイートは含めない
# - SimpleInstall=1: 推奨設定でインストール
# - Include_pip=1: pipを含める
# - Include_tcltk=1: Tkinterを含める
# - Include_launcher=1: Python Launcherを含める
# - Include_lib=1: 標準ライブラリを含める
# - Include_doc=1: ドキュメントを含める

$installArgs = @(
    "/quiet",
    "InstallAllUsers=0",
    "TargetDir=$InstallPath",
    "PrependPath=1",
    "Include_test=0",
    "Include_pip=1",
    "Include_tcltk=1",
    "Include_launcher=1",
    "Include_lib=1",
    "Include_doc=1",
    "SimpleInstall=1",
    "SimpleInstallDescription=全ての標準ライブラリと関連ファイルをインストール"
)

try {
    $process = Start-Process -FilePath $installerPath -ArgumentList $installArgs -Wait -PassThru

    if ($process.ExitCode -eq 0) {
        Write-Host "インストール完了" -ForegroundColor Green
    } else {
        Write-Host "インストールに失敗しました。終了コード: $($process.ExitCode)" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "インストール中にエラーが発生しました: $_" -ForegroundColor Red
    exit 1
}

# 環境変数の確認
Write-Host "`n環境変数の設定を確認中..." -ForegroundColor Yellow

$pythonExe = Join-Path $InstallPath "python.exe"
$scriptsPath = Join-Path $InstallPath "Scripts"

if (Test-Path $pythonExe) {
    Write-Host "Pythonの実行ファイルが見つかりました: $pythonExe" -ForegroundColor Green

    # Pythonバージョンの確認
    $installedVersion = & $pythonExe --version
    Write-Host "インストールされたバージョン: $installedVersion" -ForegroundColor Green
} else {
    Write-Host "警告: Pythonの実行ファイルが見つかりません" -ForegroundColor Red
}

# pipのアップグレード
Write-Host "`npipをアップグレード中..." -ForegroundColor Yellow
try {
    & $pythonExe -m pip install --upgrade pip
    Write-Host "pipのアップグレード完了" -ForegroundColor Green
} catch {
    Write-Host "警告: pipのアップグレードに失敗しました" -ForegroundColor Yellow
}

# 標準ライブラリの確認
Write-Host "`n標準ライブラリの確認中..." -ForegroundColor Yellow
$libPath = Join-Path $InstallPath "Lib"
if (Test-Path $libPath) {
    $libCount = (Get-ChildItem -Path $libPath -Recurse -File | Measure-Object).Count
    Write-Host "標準ライブラリディレクトリ: $libPath" -ForegroundColor Green
    Write-Host "ファイル数: $libCount" -ForegroundColor Green
} else {
    Write-Host "警告: 標準ライブラリディレクトリが見つかりません" -ForegroundColor Red
}

# 一時ファイルのクリーンアップ
Write-Host "`n一時ファイルをクリーンアップ中..." -ForegroundColor Yellow
Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "クリーンアップ完了" -ForegroundColor Green

# 完了メッセージ
Write-Host "`n" + ("=" * 60) -ForegroundColor Cyan
Write-Host "セットアップが完了しました！" -ForegroundColor Green
Write-Host ("=" * 60) -ForegroundColor Cyan
Write-Host "`nインストール情報:" -ForegroundColor White
Write-Host "  インストール先: $InstallPath" -ForegroundColor White
Write-Host "  Python実行ファイル: $pythonExe" -ForegroundColor White
Write-Host "  Scriptsディレクトリ: $scriptsPath" -ForegroundColor White
Write-Host "  標準ライブラリ: $libPath" -ForegroundColor White
Write-Host "`n次のステップ:" -ForegroundColor Yellow
Write-Host "  1. 新しいコマンドプロンプトまたはPowerShellウィンドウを開く" -ForegroundColor White
Write-Host "  2. 'python --version' でインストールを確認" -ForegroundColor White
Write-Host "  3. 'pip --version' でpipを確認" -ForegroundColor White
Write-Host "`n環境変数PATHに自動的に追加されているため、すぐに使用できます。" -ForegroundColor Green

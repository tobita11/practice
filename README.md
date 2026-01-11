# practice

## Windows Python セットアップツール

WindowsローカルマシンにPythonを `E:\python` にインストールするためのセットアップツールです。

### 📦 含まれるもの

- Python本体
- 標準ライブラリ（全て）
- pip（パッケージ管理ツール）
- Tkinter（GUI開発）
- ドキュメント
- 関連ファイル

### 🚀 クイックスタート

#### 方法1: バッチファイルを使う（最も簡単）

1. `setup-python.bat` を右クリック
2. 「管理者として実行」を選択
3. 完了を待つ

#### 方法2: PowerShellスクリプトを使う

```powershell
# PowerShellを管理者として起動
.\setup-python-windows.ps1
```

#### 方法3: マニュアルインストール

詳細な手順は [WINDOWS_PYTHON_SETUP.md](WINDOWS_PYTHON_SETUP.md) を参照してください。

### 📖 ドキュメント

- [詳細セットアップガイド](WINDOWS_PYTHON_SETUP.md) - マニュアルインストール手順、トラブルシューティング、環境変数設定など

### ✅ インストール後の確認

```powershell
python --version
pip --version
```

### 📁 ファイル説明

- `setup-python.bat` - バッチファイル（ダブルクリックで実行可能）
- `setup-python-windows.ps1` - PowerShellスクリプト（自動インストール）
- `WINDOWS_PYTHON_SETUP.md` - 詳細ドキュメント

### ⚙️ 要件

- Windows 10/11
- 管理者権限
- インターネット接続
- E:ドライブ（または別のドライブを指定）

### 🛠️ トラブルシューティング

問題が発生した場合は [WINDOWS_PYTHON_SETUP.md](WINDOWS_PYTHON_SETUP.md#よくある問題と解決方法) のトラブルシューティングセクションを参照してください。
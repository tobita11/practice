# Windows Python セットアップガイド

このガイドでは、WindowsローカルマシンにPythonをインストールする手順を説明します。

## インストール先

- **パス**: `E:\python`
- **含まれるもの**: Python本体、標準ライブラリ、pip、関連ファイル

---

## 方法1: 自動インストール（推奨）

### 前提条件

- Windows 10/11
- 管理者権限
- インターネット接続

### 手順

1. **PowerShellを管理者として起動**
   - スタートメニューで「PowerShell」を検索
   - 右クリックして「管理者として実行」を選択

2. **実行ポリシーの変更（初回のみ）**
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

3. **スクリプトの実行**
   ```powershell
   # リポジトリのディレクトリに移動
   cd path\to\practice

   # スクリプトを実行
   .\setup-python-windows.ps1
   ```

4. **カスタムバージョンを指定する場合**
   ```powershell
   .\setup-python-windows.ps1 -PythonVersion "3.11.7"
   ```

### スクリプトが実行すること

- ✅ Pythonの最新安定版をダウンロード
- ✅ `E:\python` にインストール
- ✅ 標準ライブラリをすべて含める
- ✅ pip、Tkinter、ドキュメントを含める
- ✅ 環境変数PATHに自動追加
- ✅ pipを最新版にアップグレード

---

## 方法2: マニュアルインストール

### 手順

1. **Pythonインストーラーのダウンロード**
   - 公式サイト: https://www.python.org/downloads/
   - 「Download Python 3.x.x」をクリック
   - Windows用の64bit版（amd64）をダウンロード

2. **インストーラーの起動**
   - ダウンロードした `.exe` ファイルを右クリック
   - 「管理者として実行」を選択

3. **インストールオプションの設定**

   **重要な設定:**

   ✅ **「Add Python to PATH」にチェックを入れる**

   次に「Customize installation」を選択

4. **オプション機能の選択（すべてチェック）**
   - ☑ Documentation
   - ☑ pip
   - ☑ tcl/tk and IDLE
   - ☑ Python test suite
   - ☑ py launcher
   - ☑ for all users (requires admin privileges)

5. **詳細オプションの設定**
   - ☑ Install for all users
   - ☑ Associate files with Python
   - ☑ Create shortcuts for installed applications
   - ☑ Add Python to environment variables
   - ☑ Precompile standard library
   - **Customize install location**: `E:\python` に変更
   - ☑ Download debugging symbols
   - ☑ Download debug binaries

6. **インストールの実行**
   - 「Install」をクリック
   - 完了まで待機（数分程度）

---

## インストール後の確認

### 1. PowerShellまたはコマンドプロンプトを開く

新しいウィンドウを開いてください（環境変数を反映するため）

### 2. Pythonのバージョン確認

```powershell
python --version
```

**期待される出力例:**
```
Python 3.12.1
```

### 3. pipの確認

```powershell
pip --version
```

**期待される出力例:**
```
pip 23.3.2 from E:\python\Lib\site-packages\pip (python 3.12)
```

### 4. インストール内容の確認

```powershell
# Pythonインストールディレクトリの確認
dir E:\python

# 標準ライブラリの確認
dir E:\python\Lib

# インストール済みパッケージの確認
pip list
```

### 5. 動作テスト

簡単なPythonコードを実行してみる:

```powershell
python -c "import sys; print(f'Python {sys.version}')"
python -c "import tkinter; print('Tkinter OK')"
python -c "import pip; print(f'pip {pip.__version__}')"
```

---

## ディレクトリ構造

インストール後、以下のような構造になります:

```
E:\python\
├── python.exe           # Python実行ファイル
├── pythonw.exe          # ウィンドウなしPython実行ファイル
├── python312.dll        # Pythonコアライブラリ
├── DLLs\                # 追加のDLLファイル
├── Lib\                 # 標準ライブラリ
│   ├── site-packages\   # サードパーティパッケージ
│   ├── tkinter\         # Tkinterライブラリ
│   ├── json\            # JSONライブラリ
│   ├── urllib\          # URLライブラリ
│   └── ... (その他多数の標準ライブラリ)
├── Scripts\             # スクリプトと実行ファイル
│   ├── pip.exe          # pipコマンド
│   ├── pip3.exe
│   └── ...
├── Include\             # ヘッダーファイル
├── libs\                # リンクライブラリ
└── Doc\                 # ドキュメント（オプション）
```

---

## 環境変数の確認・手動設定

### 環境変数の確認

```powershell
$env:PATH -split ';' | Select-String python
```

### 手動で環境変数を追加する場合

1. **システムのプロパティを開く**
   - `Win + Pause` キーを押す
   - または「システム」→「詳細設定」→「環境変数」

2. **システム環境変数の編集**
   - 「Path」を選択して「編集」をクリック

3. **以下のパスを追加**
   ```
   E:\python
   E:\python\Scripts
   ```

4. **変更を保存**
   - すべてのダイアログで「OK」をクリック

5. **新しいターミナルで確認**
   - 新しいPowerShellまたはコマンドプロンプトを開く
   - `python --version` で確認

---

## よくある問題と解決方法

### 問題1: 'python' は、内部コマンドまたは外部コマンド...として認識されていません

**原因**: PATHが正しく設定されていない

**解決方法**:
1. 環境変数を手動で設定（上記参照）
2. ターミナルを再起動
3. フルパスで実行: `E:\python\python.exe --version`

### 問題2: スクリプト実行時に「...スクリプトの実行が無効になっています」

**原因**: PowerShellの実行ポリシーが制限されている

**解決方法**:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 問題3: インストーラーで「E:\python」が選択できない

**原因**: E:ドライブが存在しない、または権限がない

**解決方法**:
1. E:ドライブが存在することを確認
2. 管理者権限でインストーラーを実行
3. 別のドライブ/パスを使用する場合は、スクリプトの `$InstallPath` パラメータを変更

### 問題4: pipが見つからない

**解決方法**:
```powershell
# pipを再インストール
E:\python\python.exe -m ensurepip --upgrade
E:\python\python.exe -m pip install --upgrade pip
```

---

## 標準ライブラリの確認

インストールされた標準ライブラリを確認:

```powershell
# 利用可能なモジュールのリスト
python -c "help('modules')"

# 主要な標準ライブラリのインポートテスト
python -c "import os, sys, re, json, urllib, sqlite3, tkinter, datetime, collections; print('All standard libraries OK')"
```

### 主な標準ライブラリ

- ✅ **os, sys** - システム操作
- ✅ **json, csv, xml** - データ形式
- ✅ **re** - 正規表現
- ✅ **datetime** - 日付・時刻
- ✅ **urllib, http** - ネットワーク
- ✅ **sqlite3** - データベース
- ✅ **tkinter** - GUI
- ✅ **collections, itertools** - データ構造
- ✅ **pathlib** - パス操作
- ✅ **subprocess** - プロセス実行

---

## 追加パッケージのインストール

標準ライブラリ以外のパッケージをインストールする場合:

```powershell
# 例: よく使われるパッケージ
pip install numpy pandas matplotlib requests
```

```powershell
# requirements.txtからインストール
pip install -r requirements.txt
```

---

## アンインストール

### 方法1: Windowsの設定から

1. 「設定」→「アプリ」→「アプリと機能」
2. 「Python 3.x.x」を検索
3. 「アンインストール」をクリック

### 方法2: 手動削除

1. `E:\python` ディレクトリを削除
2. 環境変数PATHから `E:\python` と `E:\python\Scripts` を削除

---

## サポート

問題が発生した場合:

- Python公式ドキュメント: https://docs.python.org/ja/3/
- Windows固有の問題: https://docs.python.org/ja/3/using/windows.html
- コミュニティフォーラム: https://www.python.jp/

---

## まとめ

✅ Pythonが `E:\python` にインストールされました
✅ すべての標準ライブラリが含まれています
✅ pip、Tkinter、その他の関連ファイルが利用可能です
✅ 環境変数PATHに追加され、すぐに使用できます

これでPython開発環境の準備が整いました！

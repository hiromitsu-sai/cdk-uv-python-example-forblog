
# Welcome to your CDK Python project!

You should explore the contents of this project. It demonstrates a CDK app with an instance of a stack (`cdk_uv_python_example_stack`)
which contains an Amazon SQS queue that is subscribed to an Amazon SNS topic.

The `cdk.json` file tells the CDK Toolkit how to execute your app.

This project is set up like a standard Python project.  The initialization process also creates
a virtualenv within this project, stored under the .venv directory.  To create the virtualenv
it assumes that there is a `python3` executable in your path with access to the `venv` package.
If for any reason the automatic creation of the virtualenv fails, you can create the virtualenv
manually once the init process completes.

To manually create a virtualenv on MacOS and Linux:

```
$ python3 -m venv .venv
```

After the init process completes and the virtualenv is created, you can use the following
step to activate your virtualenv.

```
$ source .venv/bin/activate
```

If you are a Windows platform, you would activate the virtualenv like this:

```
% .venv\Scripts\activate.bat
```

Once the virtualenv is activated, you can install the required dependencies.

```
$ pip install -r requirements.txt
```

At this point you can now synthesize the CloudFormation template for this code.

```
$ cdk synth
```

You can now begin exploring the source code, contained in the hello directory.
There is also a very trivial test included that can be run like this:

```
$ pytest
```

To add additional dependencies, for example other CDK libraries, just add to
your requirements.txt file and rerun the `pip install -r requirements.txt`
command.

## Useful commands

 * `cdk ls`          list all stacks in the app
 * `cdk synth`       emits the synthesized CloudFormation template
 * `cdk deploy`      deploy this stack to your default AWS account/region
 * `cdk diff`        compare deployed stack with current state
 * `cdk docs`        open CDK documentation

Enjoy!

# Additional Changes

uv で python 3.11 をインストールする

```bash
$ uv python install 3.11
```

venv で仮想環境を作成する

```bash
$ uv venv --python 3.11
Using Python 3.11.9
Creating virtualenv at: .venv
Activate with: source .venv/bin/activate
$ uv run python -V
Python 3.11.9
$ 
```

uv でプロジェクトを初期化する

```bash
$ uv init
Initialized project `cdk-uv-python-example-forblog`
```

`src/`, `tests/` ディレクトリをにコードを配置する

```bash
$ mkdir -p src
$ mv hello.py src/hello.py  # Lambda用のコードを配置して内容を記述
$ touch tests/test_hello.py # テストを配置して内容を記述
```

uv で python パッケージを管理する

```bash
## requirements.txt からパッケージを追加
$ uv add -r requirements.txt
$ uv add -r requirements.txt --dev
$ rm requirements.txt requirements-dev.txt source.bat
$ uv add ruff --dev
$ uv run python -m hello
$ uv run ruff check
All checks passed!
$ uv run python -m pytest tests -v
```

cdk でスタックをデプロイする

```bash
$ uv run npx cdk bootstrap --profile default --context env=dev # 初回のみ行う bootstrapping
$ uv run npx cdk synth --profile default --context env=dev --all
$ uv run npx cdk deploy --profile default --context env=dev --all
```

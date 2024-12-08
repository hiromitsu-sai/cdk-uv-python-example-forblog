FROM public.ecr.aws/lambda/python:3.11

# uv 公式のインストール手順で uv をインストールする
# https://docs.astral.sh/uv/guides/integration/docker/#installing-uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv
ENV PATH="/app/.venv/bin:$PATH"

# Set Evnvars
ENV LOGLEVEL=${LOGLEVEL:-DEBUG}
ENV IS_DEBUG=${IS_DEBUG:-1}
ENV PYTHONUTF8=1
# uv のキャッシュディレクトリを Lambdaのエフェメラルストレージ配下である /tmp/.uv_cache に変更する。
# Lambda のコンテナイメージはエフェメラルストレージが唯一書込可能なディレクトリなので、このような措置を採る。
# UV_NO_CACHE=1 してキャッシュを利用しない設定とすることで、書込可能なディレクトリ自体を不要とすることもできる。
# いずれかの措置をトラない場合は `error: failed to create directory `/home/xxxxx/.cache/uv` Caused by: Read-only file system (os error 30)` が発生する。
# 参考:
#   - https://repost.aws/questions/QUyYQzTTPnRY6_2w71qscojA/read-only-file-system-aws-lambda#ANzVYu4lO8TmGfblJGL40hdg
#   - https://docs.astral.sh/uv/configuration/environment/#uv_cache_dir
#   - https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/configuration-ephemeral-storage.html
ENV UV_CACHE_DIR=/tmp/.uv_cache

# uv で Python 仮想環境を作成する
COPY pyproject.toml uv.lock ${LAMBDA_TASK_ROOT}/
RUN uv sync --frozen

# Lambda関数のコードをコンテナイメージにコピーする
COPY src/ ${LAMBDA_TASK_ROOT}/

# デフォルトのエントリーポイント "/lambda-entrypoint.sh" を、uv で作成した Python 仮想環境で実行するように変更
ENTRYPOINT ["uv", "run", "/lambda-entrypoint.sh"]

# 実行したいLambdaのハンドラのロケーションを CMD で指定する考え方がこのコンテナイメージのデフォルトである。
# cdk でデプロイする場合には aws_lambda.DockerImageCode.from_image_asset() で CMD を指定することで、Lambda関数のハンドラを指定できる。
# CMD ["hello.handler"]

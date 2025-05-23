# 使用 Python 3.11 的 slim 镜像作为基础
FROM python:3.11-slim

# 设置工作目录
WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 安装 Python 依赖
RUN pip install mcpo uv

# 复制项目文件
COPY . .

# 创建虚拟环境并安装依赖
RUN uv venv && \
    . .venv/bin/activate && \
    uv pip install -e ".[dev]"

# 暴露端口
EXPOSE 8811

# 设置环境变量
ENV PROXMOX_MCP_CONFIG="/app/proxmox-config/config.json"
ENV API_HOST="0.0.0.0"
ENV API_PORT="8811"

# 启动命令
CMD ["mcpo", "--host", "0.0.0.0", "--port", "8811", "--", \
     "/bin/bash", "-c", "cd /app && source .venv/bin/activate && python -m proxmox_mcp.server"]
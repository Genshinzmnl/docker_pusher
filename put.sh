#!/bin/bash

CONFIG_FILE="config.json"

# 检查配置文件是否存在
if [ ! -f "$CONFIG_FILE" ]; then
  echo "配置文件未找到，将引导您输入必要信息并保存。"
  read -p "请输入阿里云镜像仓库地址: " ALIYUN_REGISTRY
  read -p "请输入命名空间: " ALIYUN_NAME_SPACE
  read -s -p "请输入用户名: " ALIYUN_REGISTRY_USER
  echo ""
  read -s -p "请输入密码: " ALIYUN_REGISTRY_PASSWORD
  echo ""

  # 将输入的信息保存到config.json
  echo "{\"registry\":\"$ALIYUN_REGISTRY\",\"namespace\":\"$ALIYUN_NAME_SPACE\",\"user\":\"$ALIYUN_REGISTRY_USER\",\"password\":\"$ALIYUN_REGISTRY_PASSWORD\"}" > "$CONFIG_FILE"
  chmod 600 "$CONFIG_FILE" # 限制文件权限，保护敏感信息
else
  # 从config.json读取信息
  export $(grep -oP '(?<=^|"\s*):\s*"\K[^"]+' "$CONFIG_FILE" | sed -e 's/^/export /')
fi

# 显示使用说明
echo "欢迎使用本脚本！"
echo "脚本将执行以下操作:"
echo "- 使用已配置的凭据登录阿里云镜像仓库"
echo "- 根据images.txt文件中的列表，拉取镜像、重命名并推送到阿里云"

# 登录阿里云镜像仓库
docker login -u "$ALIYUN_REGISTRY_USER" -p "$ALIYUN_REGISTRY_PASSWORD" "$ALIYUN_REGISTRY" || { echo "登录失败，请检查凭据是否正确。"; exit 1; }

# 处理images.txt中的镜像
while IFS= read -r line; do
  if [ -n "$line" ]; then
    echo "正在处理镜像: $line"
    docker pull "$line" || { echo "拉取镜像失败: $line"; continue; }
    image=$(basename "$line")
    new_image="$ALIYUN_REGISTRY/$ALIYUN_NAME_SPACE/$image"
    echo "重命名镜像为: $new_image"
    docker tag "$line" "$new_image" || { echo "重命名镜像失败: $line"; continue; }
    echo "推送镜像: $new_image"
    docker push "$new_image" || { echo "推送镜像失败: $new_image"; continue; }
  fi
done < images.txt

echo "所有操作已完成。"

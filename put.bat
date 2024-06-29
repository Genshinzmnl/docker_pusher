@echo off
setlocal enabledelayedexpansion

set "CONFIG_FILE=config.json"

if not exist "%CONFIG_FILE%" (
  echo 配置文件未找到，将引导您输入必要信息并保存。
  set /p "ALIYUN_REGISTRY=请输入阿里云镜像仓库地址: "
  set /p "ALIYUN_NAME_SPACE=请输入命名空间: "
  set /p "ALIYUN_REGISTRY_USER=请输入用户名: "
  set /p "ALIYUN_REGISTRY_PASSWORD=请输入密码: "

  echo {"registry":"%ALIYUN_REGISTRY%","namespace":"%ALIYUN_NAME_SPACE%","user":"%ALIYUN_REGISTRY_USER%","password":"%ALIYUN_REGISTRY_PASSWORD%"} > "%CONFIG_FILE%"
) else (
  for /f "delims=" %%i in (%CONFIG_FILE%) do (
    set "line=%%i"
    for /f "tokens=1,2 delims=:" %%a in ("!line!") do (
      set "key=%%a"
      set "value=%%b"
      set "!key: =!=!value!"
    )
  )
)

echo 欢迎使用本脚本！
echo 脚本将执行以下操作:
echo - 使用已配置的凭据登录阿里云镜像仓库
echo - 根据images.txt文件中的列表，拉取镜像、重命名并推送到阿里云

rem 登录阿里云镜像仓库
docker login -u %ALIYUN_REGISTRY_USER% -p %ALIYUN_REGISTRY_PASSWORD% %ALIYUN_REGISTRY% || goto :error

rem 处理images.txt中的镜像
for /F "usebackq delims=" %%i in (images.txt) do (
  if defined %%i (
    echo 正在处理镜像: %%i
    docker pull %%i || goto :skip
    set "image=%%~ni"
    set "new_image=%ALIYUN_REGISTRY%/%ALIYUN_NAME_SPACE%/!image!"
    echo 重命名镜像为: !new_image!
    docker tag %%i !new_image! || goto :skip
    echo 推送镜像: !new_image!
    docker push !new_image! || goto :skip
  )
  :skip
)

echo 所有操作已完成。
goto :eof

:error
echo 发生错误，请检查配置和操作权限。
:end

import os
from openai import OpenAI
import requests
from dotenv import load_dotenv
from PIL import Image, ImageDraw, ImageFont
import io

# 加载环境变量
load_dotenv()

# 获取 API key
api_key = os.getenv('OPENAI_API_KEY')

def generate_app_icon():
    """生成 App 图标"""
    try:
        # 设置 API 请求头
        client = OpenAI(api_key=api_key)
        
        # 生成图标
        response = client.images.generate(
            model="dall-e-3",
            prompt="Design a modern, minimalist app icon for a recipe app called 'Random Eats'. The icon should feature a stylized fork and knife in a playful arrangement, with a dice element incorporated to represent randomness. Use a clean, appealing color scheme suitable for both light and dark modes. The design should be simple enough to be recognizable at small sizes. IMPORTANT: The design must fill the entire square canvas with NO white borders or padding. The icon should extend to all edges of the canvas.",
            n=1,
            size="1024x1024",
            quality="standard",
            response_format="url"
        )
        
        # 获取图片 URL
        image_url = response.data[0].url
        
        # 下载图片
        image_response = requests.get(image_url)
        image = Image.open(io.BytesIO(image_response.content))
        
        # 创建必要的目录
        icon_dir = "RandomEats/Assets.xcassets/AppIcon.appiconset"
        os.makedirs(icon_dir, exist_ok=True)
        
        # 保存原始图片
        icon_path = os.path.join(icon_dir, "app_icon.png")
        image.save(icon_path, "PNG")
        
        # 更新 Contents.json
        contents_json = {
            "images": [
                {
                    "filename": "app_icon.png",
                    "idiom": "universal",
                    "platform": "ios",
                    "size": "1024x1024"
                }
            ],
            "info": {
                "author": "xcode",
                "version": 1
            }
        }
        
        # 保存 Contents.json
        import json
        with open(os.path.join(icon_dir, "Contents.json"), "w") as f:
            json.dump(contents_json, f, indent=2)
            
        print("✅ App 图标生成成功！")
        return True
            
    except Exception as e:
        print(f"❌ 生成图标时出错: {str(e)}")
        return False

if __name__ == "__main__":
    generate_app_icon()

import os
from openai import OpenAI
import requests
from dotenv import load_dotenv
from PIL import Image, ImageOps
import io
import numpy as np

# 加载环境变量
load_dotenv()

# 获取 API key
api_key = os.getenv('OPENAI_API_KEY')

def expand_to_edges(image):
    """扩展图像到边缘，移除所有空白"""
    # 转换为 RGBA 模式
    image = image.convert('RGBA')
    
    # 获取图像数据
    image_data = np.array(image)
    
    # 获取 alpha 通道
    alpha = image_data[:, :, 3]
    
    # 找到非透明像素的边界
    rows = np.any(alpha > 0, axis=1)
    cols = np.any(alpha > 0, axis=0)
    y_min, y_max = np.where(rows)[0][[0, -1]]
    x_min, x_max = np.where(cols)[0][[0, -1]]
    
    # 裁剪图像
    cropped = image.crop((x_min, y_min, x_max + 1, y_max + 1))
    
    # 计算新的尺寸，确保图像完全填充
    target_size = 1024
    
    # 计算缩放比例
    width_ratio = target_size / cropped.size[0]
    height_ratio = target_size / cropped.size[1]
    scale_ratio = max(width_ratio, height_ratio) * 1.2  # 放大 20% 确保完全覆盖
    
    # 计算新的尺寸
    new_width = int(cropped.size[0] * scale_ratio)
    new_height = int(cropped.size[1] * scale_ratio)
    
    # 放大图像
    enlarged = cropped.resize((new_width, new_height), Image.Resampling.LANCZOS)
    
    # 创建最终的正方形画布
    final = Image.new('RGBA', (target_size, target_size), (0, 0, 0, 0))
    
    # 计算粘贴位置（居中）
    paste_x = (target_size - new_width) // 2
    paste_y = (target_size - new_height) // 2
    
    # 粘贴放大的图像
    final.paste(enlarged, (paste_x, paste_y))
    
    return final

def generate_app_icon():
    """生成 App 图标"""
    try:
        # 设置 API 请求头
        client = OpenAI(api_key=api_key)
        
        # 生成图标
        response = client.images.generate(
            model="dall-e-3",
            prompt="Design a modern app icon for a recipe randomizer app. Create a playful and appetizing design that combines a dice with food elements. The main focus should be a stylized steaming bowl or plate with food (like noodles, rice, or a mixed dish) emerging from or sitting atop a dice. The steam could form interesting patterns. Use warm, appetizing colors that make people think of delicious food. The design should be bold and clear enough to be recognizable at small sizes. The icon must be a single cohesive design with NO background - just the icon elements themselves with transparency around it. Think of the simplicity of food delivery app icons but with a playful gambling/random element incorporated. The design should fill the entire space while maintaining clear visual hierarchy.",
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
        
        # 处理图像
        processed_image = expand_to_edges(image)
        
        # 创建必要的目录
        icon_dir = "RandomEats/Assets.xcassets/AppIcon.appiconset"
        os.makedirs(icon_dir, exist_ok=True)
        
        # 保存处理后的图片
        icon_path = os.path.join(icon_dir, "app_icon.png")
        processed_image.save(icon_path, "PNG")
        
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

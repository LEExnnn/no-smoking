import sys
from PIL import Image, ImageChops

def crop_black(image_path, output_path):
    img = Image.open(image_path).convert("RGBA")
    
    # We create a mask of non-black pixels
    # Let's say black is < 20
    data = img.getdata()
    mask_data = []
    for item in data:
        if item[0] < 20 and item[1] < 20 and item[2] < 20:
            mask_data.append(0)
        else:
            mask_data.append(255)
            
    mask = Image.new("L", img.size)
    mask.putdata(mask_data)
    
    bbox = mask.getbbox()
    if bbox:
        img = img.crop(bbox)
        # For iOS, we don't want transparent corners if it's a rounded rect.
        # But if it's a rounded rect, cropping it will still leave some black if it's rounded?
        # Actually, cropping to bbox will remove the *outer* black padding.
        # Let's just make the remaining black transparent.
        img_data = img.getdata()
        new_data = []
        for item in img_data:
            if item[0] < 20 and item[1] < 20 and item[2] < 20:
                new_data.append((255, 255, 255, 0)) # transparent
            else:
                new_data.append(item)
        img.putdata(new_data)
    
    img.save(output_path)

crop_black('../app/assets/icon.png', '../app/assets/icon.png')

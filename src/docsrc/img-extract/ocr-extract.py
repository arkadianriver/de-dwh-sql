# from PIL import Image
import pytesseract
from PIL import Image

# Provide the name/path of your file image
image_path = "../../../datasets/source_images/spec-table-capture.png"

# Open the image using Pillow
img = Image.open(image_path)

# Use pytesseract to extract the text
text = pytesseract.image_to_string(img)

# Print the final result
print(text)

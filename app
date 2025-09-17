from flask import Flask, render_template, request, redirect, url_for
import os
from werkzeug.utils import secure_filename

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = 'uploads'

artisans = []

ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.',1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/')
def home():
    return render_template('index.html', artisans=artisans)

@app.route('/add', methods=['POST'])
def add_artisan():
    name = request.form.get('name')
    craft = request.form.get('craft')
    story = request.form.get('story')
    image = request.files.get('image')

    if name and craft and story:
        img_filename = None
        if image and allowed_file(image.filename):
            img_filename = secure_filename(image.filename)
            image.save(os.path.join(app.config['UPLOAD_FOLDER'], img_filename))

        description = f"{name}'s craft is creative, unique, and perfect for digital audiences!"

        artisans.append({
            'name': name,
            'craft': craft,
            'story': story,
            'image': img_filename,
            'description': description
        })
    return redirect(url_for('home'))

if __name__ == '__main__':
    app.run(debug=True)

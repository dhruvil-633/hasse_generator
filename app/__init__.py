from flask import Flask

def create_app():
    app = Flask(__name__)
    
    # Configuration
    app.config.from_object('config.Config')
    
    # Import and register blueprint
    from app.routes import bp
    app.register_blueprint(bp, url_prefix='/')
    
    # Simple test route
    @app.route('/ping')
    def ping():
        return "pong", 200
        
    return app
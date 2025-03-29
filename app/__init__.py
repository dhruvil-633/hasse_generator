from flask import Flask

def create_app(config_class='config'):
    app = Flask(__name__)
    app.config.from_object(config_class)

    from app import routes
    app.register_blueprint(routes.bp)

    return app
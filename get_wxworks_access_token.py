from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
import requests

app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+mysqlconnector://dbuser:dbpass@dbhost:dbport/dbname'
db = SQLAlchemy(app)

class WXConfig(db.Model):
    __tablename__ = 'wx_config'  
    id = db.Column(db.Integer, primary_key=True)
    corpid = db.Column(db.String(255), nullable=False)
    agentid = db.Column(db.String(255), nullable=False)
    secret = db.Column(db.String(255), nullable=False)

with app.app_context():
    db.create_all()

@app.route('/get_wxwork_access_token', methods=['GET'])
def get_access_token():
    agentid = request.args.get('agentid')

    if not agentid:
        return jsonify({'error': 'Missing agentid parameter'}), 400

    wx_config = WXConfig.query.filter_by(agentid=agentid).first()

    if not wx_config:
        return jsonify({'error': 'Invalid agentid'}), 400

    corp_secret = wx_config.secret
    access_token = get_access_token_from_wx(wx_config.corpid, corp_secret)

    if access_token:
        return jsonify({'access_token': access_token})
    else:
        return jsonify({'error': 'Failed to get access token'}), 500

def get_access_token_from_wx(corpid, corp_secret):
    url = f"https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid={corpid}&corpsecret={corp_secret}"

    response = requests.get(url)
    data = response.json()

    if response.status_code == 200 and 'access_token' in data:
        return data['access_token']
    else:
        return None

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)

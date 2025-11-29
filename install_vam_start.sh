# install_vam_start.sh
sudo apt update
sudo apt install -y python3-pip python3-venv
python3 -m venv vam_env
source vam_env/bin/activate
pip install flask RPi.GPIO --quiet

mkdir -p ~/vam_start/templates
cp vam_start_v11.py ~/vam_start/app.py
cp control.html ~/vam_start/templates/

# Auto-start service
sudo tee /etc/systemd/system/vam-start.service > /dev/null <<EOF
[Unit]
Description=VAM! START v11.0
After=network.target

[Service]
Type=simple
User=pi
WorkingDirectory=/home/pi/vam_start
Environment=PATH=/home/pi/vam_start/vam_env/bin
ExecStart=/home/pi/vam_start/vam_env/bin/python app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now vam-start.service

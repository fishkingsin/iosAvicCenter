#include "testApp.h"
#include "Settings.h"
ofRectangle restBtnRect;
ofPoint readyButtonPoint;
//--------------------------------------------------------------
void testApp::setup(){
	ofEnableSmoothing();
	port = Settings::getInt("Port" , 2838);
    host = Settings::getString("Host" , "192.168.6.133");
	
	
	ofSetFrameRate(25);
	subGUIRect.set(303,214,450,782);
	restBtnRect.set(488,941,212,51);
	readyButtonPoint.set(186,729);
	// initialize the accelerometer
	ofxAccelerometer.setup();
	ofSetLogLevel(OF_LOG_WARNING);
//    ofSetLogLevel(OF_LOG_VERBOSE);
	
	//If you want a landscape oreintation
	//iPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
	
	ofBackground(127,127,127);
	
	setGUI1();
	setGUI2();
    setGUI3();
    setGUI4();
    setGUI5();

	
	if(scroll!=NULL)scroll->hightLightIdx =  Settings::getInt("ZONE4_LAST_PAGE" , 0);

	
	canvases.push_back(gui1);
	canvases.push_back(gui2);
	canvases.push_back(gui3);
	canvases.push_back(gui4);
	canvases.push_back(gui5);

	for(int i = 0 ; i < canvases.size(); i++)
	{
		canvases[i]->loadSettings("GUI/GUI_"+ofToString(i)+"_DEFAULT_SETTING.xml");
		vector <ofxUIWidget*> widgets = canvases[i]->getWidgetsOfType(OFX_UI_WIDGET_MULTIIMAGETOGGLE);
		for (vector <ofxUIWidget*>::iterator it = widgets.begin(); it!= widgets.end() ; it++) {
			(*it)->setVisible(true);
			
			((ofxUIMultiImageToggle*)(*it))->setLabelVisible(false);
		}
		canvases[i]->setDrawBack((ofGetLogLevel()==OF_LOG_VERBOSE));
    	canvases[i]->setDrawWidgetPaddingOutline(false);
		
		
		canvases[i]->setDrawWidgetPadding(false);
	}
	backgrounds.push_back(ofImage("GUI/images/page_zone2.png"));
	backgrounds.push_back(ofImage("GUI/images/page_zone3.png"));
	backgrounds.push_back(ofImage("GUI/images/page_zone4.png"));
	backgrounds.push_back(ofImage("GUI/images/page_zone5.png"));
	
	
	weConnected = tcpClient.setup(host,port);
	//optionally set the delimiter to something else.  The delimter in the client and the server have to be the same
	tcpClient.setMessageDelimiter("\n");
	if(weConnected)
    {
        connected->setVisible(true);
        disconnected->setVisible(false);
    }else
    
    {
        connected->setVisible(false);
        disconnected->setVisible(true);
    }
	connectTime = 0;
	deltaTime = 0;
	
	tcpClient.setVerbose(true);
	
	sFX.loadSound("CLICK17C.wav");
	sFX.setVolume(0.1);
	
//	retina.setNearestMagnification(); // just to make more obvious when using non-retina on a retina screen
	
}
void testApp::exit()
{
	delete gui1;
	delete gui2;
    delete gui3;
    delete gui4;
	delete gui5;

	
}
void testApp::scrollEvent(MyScrollViewEventArgs &e)
{
	ofLogVerbose() << "scrollEvent: " << "Index: " << e.index;
	
	if(tcpClient.isConnected())tcpClient.send("ZONE_4_MAIN_"+ofToString(e.index));
}
bool testApp::isCoolDown()
{
	bool cooldown = (abs(coolDown -ofGetElapsedTimef())>OVERHEAT);
    
	if(cooldown)sFX.play();
	return  cooldown;
}
void  testApp::overHeat()
{
	coolDown  = ofGetElapsedTimef();
}
//--------------------------------------------------------------
void testApp::guiEvent(ofxUIEventArgs &e)
{
	string name = e.widget->getName();
	int kind = e.widget->getKind();

	ofLogVerbose() << "got event from: " << name << " kind " << kind << endl;
	if(kind==3 )
	{
		
		if(!isCoolDown())return;
		
	}
	if (kind==30)
	{
		
		if(!isCoolDown())return;
		
	}
	if (kind!=3 && kind!=30){

		if(!isCoolDown())return;
		
	}
	
	if(name == "ZONE2")
	{

		
		((ofxUIToggle*)gui1->getWidget("ZONE3"))->setValue(false);
		((ofxUIToggle*)gui1->getWidget("ZONE4"))->setValue(false);
		((ofxUIToggle*)gui1->getWidget("ZONE5"))->setValue(false);
		gui2->setVisible(true);
		gui3->setVisible(false);
		gui4->setVisible(false);
		gui5->setVisible(false);

		
	}
	else if(name == "ZONE3")
	{
		((ofxUIToggle*)gui1->getWidget("ZONE2"))->setValue(false);
		((ofxUIToggle*)gui1->getWidget("ZONE4"))->setValue(false);
		((ofxUIToggle*)gui1->getWidget("ZONE5"))->setValue(false);
		gui3->setVisible(true);
		gui2->setVisible(false);
		gui4->setVisible(false);
		gui5->setVisible(false);
		
		
		
	}
	else if(name == "ZONE4")
	{
		((ofxUIToggle*)gui1->getWidget("ZONE2"))->setValue(false);
		((ofxUIToggle*)gui1->getWidget("ZONE3"))->setValue(false);
		((ofxUIToggle*)gui1->getWidget("ZONE5"))->setValue(false);
		gui4->setVisible(true);
		gui3->setVisible(false);
		gui2->setVisible(false);
		gui5->setVisible(false);
		
		
		
		
	}
	
	else if(name == "ZONE5")
	{
		((ofxUIToggle*)gui1->getWidget("ZONE2"))->setValue(false);
		((ofxUIToggle*)gui1->getWidget("ZONE3"))->setValue(false);
		((ofxUIToggle*)gui1->getWidget("ZONE4"))->setValue(false);
		gui5->setVisible(true);
		gui3->setVisible(false);
		gui2->setVisible(false);
		gui4->setVisible(false);

		
		
	}
	else if(name == "BUTTON_UP"){
        overHeat();
//		if(!((ofxUIButton*)e.widget)->getValue())
		{
			{
				
				scroll->prevItem();
				ofLogVerbose(name)<<e.widget->getRect()->getPosition().y;
			}
		}
	}
	else if(name == "BUTTON_DOWN"){
        overHeat();
//		if(!((ofxUIButton*)e.widget)->getValue())
		{
			{
				
				scroll->nextItem();
				ofLogVerbose(name)<<e.widget->getRect()->getPosition().y;
			}
		}
		
	}
	else if(name == "RESET_ALL" && !((ofxUIButton*)e.widget)->getValue())
	{
		for(int i = 0 ; i < canvases.size(); i++)
		{
			canvases[i]->loadSettings("GUI/GUI_"+ofToString(i)+"_DEFAULT_SETTING.xml");
			vector <ofxUIWidget*> widgets = canvases[i]->getWidgetsOfType(OFX_UI_WIDGET_MULTIIMAGETOGGLE);
			for (vector <ofxUIWidget*>::iterator it = widgets.begin(); it!= widgets.end() ; it++) {
				(*it)->setVisible(true);
				
				((ofxUIMultiImageToggle*)(*it))->setLabelVisible(false);
			}
		}
		scroll->reset();
//		if(tcpClient.isConnected())tcpClient.send(name);
	}
	
	else if(name == "Z4_READY")
	{
		scroll->reset();
		restoreDefaultSetting(3);
		if(tcpClient.isConnected())tcpClient.send("ZONE_4_MAIN_"+ofToString(0));
	}
	else if(name == "Z2_READY")
	{
		restoreDefaultSetting(1);
	}
	else if(name == "Z3_READY")
	{
		restoreDefaultSetting(2);
	}
	else if(name == "Z5_READY")
	{
		restoreDefaultSetting(4);
	}
    else if(kind == 31)
    {
        
        if(tcpClient.isConnected())tcpClient.send(name+"_"+ofToString(((ofxUIToggle*)e.widget)->getValue()));
    }
    else if(kind == OFX_UI_WIDGET_BUTTON || kind == OFX_UI_WIDGET_MULTIIMAGEBUTTON)
    {
        
        if(tcpClient.isConnected())tcpClient.send(name+"_"+ofToString(((ofxUIButton*)e.widget)->getValue()));
    }
    else
    {
        tcpClient.send(name);
    }


	
}
void testApp::restoreDefaultSetting(int i)
{
	canvases[i]->loadSettings("GUI/GUI_"+ofToString(i)+"_SAVED_SETTING.xml");
	vector <ofxUIWidget*> widgets = canvases[i]->getWidgetsOfType(OFX_UI_WIDGET_MULTIIMAGETOGGLE);
	for (vector <ofxUIWidget*>::iterator it = widgets.begin(); it!= widgets.end() ; it++) {
		(*it)->setVisible(true);
		
		((ofxUIMultiImageToggle*)(*it))->setLabelVisible(false);
	}

}

//--------------------------------------------------------------
void testApp::update(){
	if(weConnected){
		
		//TO-DO
		//recieve somthing
		string rev = tcpClient.receive();
		if(rev!="")ofLogNotice("tcpClient") << rev;
		if(!tcpClient.isConnected()){
			weConnected = false;
			
		}
		

	}else{
		//if we are not connected lets try and reconnect every 5 seconds
		deltaTime = ofGetElapsedTimeMillis() - connectTime;
		
		if( deltaTime > 5000 ){
			weConnected = tcpClient.setup(host,port);
			connectTime = ofGetElapsedTimeMillis();
			if(weConnected)
			{
				ofLogWarning() << "Network Connected!!!";
				connected->setVisible(true);
				disconnected->setVisible(false);
			}
			else
			{
				ofLogWarning() << "Network Disconnected!!!";
				connected->setVisible(false);
				disconnected->setVisible(true);
			}
		}
		
	}
}

//--------------------------------------------------------------
void testApp::draw(){
//	retina.setupScreenOrtho();
	ofBackground(255);
	if(gui2->isVisible())backgrounds[0].draw(0, 0);
	if(gui3->isVisible())backgrounds[1].draw(0, 0);
	if(gui4->isVisible())backgrounds[2].draw(0, 0);
	if(gui5->isVisible())backgrounds[3].draw(0, 0);

	//	background.draw(0,0);
	if (gui4->isVisible()) {
		scroll->draw();
	}
//	if(weConnected)
//	{
//		//draw connected annotation
//		network_status[1].draw(gui1->getRect()->x+44,gui1->getRect()->y+ 769);
//	}
//	else{
//		network_status[0].draw(44,gui1->getRect()->y+ 769);
//		//draw disconnect annotation
//	}
//	ofDrawBitmapString(ofToString(ofGetFrameRate()), 20,20);
	//	scroll->drawScrollableRect();
}


//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){
	
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){
	
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){
	
}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs & touch){
	
}

//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void testApp::lostFocus(){
	ofLogNotice() << "Lost Focus Save Settings";
	for(int i = 0 ; i < canvases.size(); i++)
	{
		canvases[i]->saveSettings("GUI/GUI_"+ofToString(i)+"_SAVED_SETTING.xml");
	}
	 Settings::setInt(scroll->hightLightIdx ,"ZONE4_LAST_PAGE" );
}

//--------------------------------------------------------------
void testApp::gotFocus(){
	ofLogNotice() << "Got Focus Load Settings";
	for(int i = 0 ; i < canvases.size(); i++)
	{
		canvases[i]->loadSettings("GUI/GUI_"+ofToString(i)+"_SAVED_SETTING.xml");
		vector <ofxUIWidget*> widgets = canvases[i]->getWidgetsOfType(OFX_UI_WIDGET_MULTIIMAGETOGGLE);
		for (vector <ofxUIWidget*>::iterator it = widgets.begin(); it!= widgets.end() ; it++) {
			(*it)->setVisible(true);
			
			((ofxUIMultiImageToggle*)(*it))->setLabelVisible(false);
		}
	}	port = Settings::getInt("Port" , 2838);
    host = Settings::getString("Host" , "192.168.6.133");
	if(scroll!=NULL)scroll->hightLightIdx =  Settings::getInt("ZONE4_LAST_PAGE" , 0);
}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){
	
}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){
	
}
//--------------------------------------------------------------
void testApp::setGUI1(){
	float dim = 228;
	float dim_h = 55;
	float xInit = OFX_UI_GLOBAL_WIDGET_SPACING;
    float length = 231+xInit;
	
	gui1 = new ofxUICanvas(0,182, length+xInit, ofGetHeight());
	
	
	ofxUIButton *toggle;
	//	ofxUIMultiImageToggle *btn;
	toggle = new ofxUIButton("ZONE2", false, dim, dim_h,0,0);
	toggle->setLabelVisible(false);
	gui1->addWidget(toggle);
	toggle = new ofxUIButton("ZONE3", false, dim, dim_h,0,(dim_h+10));
	toggle->setLabelVisible(false);
	gui1->addWidget(toggle);
	toggle = new ofxUIButton("ZONE4", false, dim, dim_h,0,(dim_h+10)*2);
	toggle->setLabelVisible(false);
	gui1->addWidget(toggle);
	toggle = new ofxUIButton("ZONE5", false, dim, dim_h,0,(dim_h+10)*3);
	toggle->setLabelVisible(false);
	gui1->addWidget(toggle);
	
	ofxUIButton* button = new ofxUIButton("RESET_ALL", false, 150,100,44,636);
	gui1->addWidget(button);
	button->setLabelVisible(false);
	
	ofImage * new_img;
	
	new_img = new ofImage();
	new_img->loadImage("GUI/images/network_fail.png");
	disconnected = new ofxUIImage(44,769 , new_img->getWidth(), new_img->getHeight() , new_img, "DISCONNECTED" , false);
	gui1->addWidget(disconnected);
	disconnected->setVisible(true);
	
	new_img = new ofImage();
	new_img->loadImage("GUI/images/network_ok.png");
	connected = new ofxUIImage(44,769 , new_img->getWidth(), new_img->getHeight(), new_img, "CONNECTED" , false);
	gui1->addWidget(connected);
	connected->setVisible(false);
	
	ofAddListener(gui1->newGUIEvent,this,&testApp::guiEvent);
}
//--------------------------------------------------------------
void testApp::setGUI2(){
	
	
	gui2 = new ofxUICanvas(subGUIRect);
	gui2->setVisible(true);


	int startX = 217;
	int startY = 193;
	int padW = 112;
	int padH = 76;
	int pngWidth = 103;
	int toggleWidth = 214;
	ofxUIMultiImageToggle* toggle = new ofxUIMultiImageToggle(startX,startY, toggleWidth, 52, false, "GUI/images/button.png","ZONE2_CURTAIN");
	toggle->setLabelVisible(false);
	gui2->addWidget(toggle);

	toggle = new ofxUIMultiImageToggle(startX,startY+padH, toggleWidth, 52, false, "GUI/images/button.png","ZONE2_LIGHT");
	toggle->setLabelVisible(false);
	gui2->addWidget(toggle);
	
	
	ofxUIMultiImageButton*btn = new ofxUIMultiImageButton(startX,startY+padH*2, pngWidth, 52, false, "GUI/images/button_lighter.png","ZONE2_LIGHT_LIGHTER");
	btn->setLabelVisible(false);
	gui2->addWidget(btn);
	
	btn = new ofxUIMultiImageButton(startX+padW,startY+padH*2, pngWidth, 52, false, "GUI/images/button_darker.png","ZONE2_LIGHT_DARKER");
	btn->setLabelVisible(false);
	gui2->addWidget(btn);
	
	toggle = new ofxUIMultiImageToggle(startX,startY+padH*3, toggleWidth, 52, false, "GUI/images/button.png","ZONE2_DOOR");
	toggle->setLabelVisible(false);
	gui2->addWidget(toggle);



	ofxUIButton*button = new ofxUIButton("Z2_READY",false,toggleWidth, 52,readyButtonPoint.x,readyButtonPoint.y);
	button->setLabelVisible(false);
	gui2->addWidget(button);

	
	ofAddListener(gui2->newGUIEvent,this,&testApp::guiEvent);
}//--------------------------------------------------------------
void testApp::setGUI3(){
	
	gui3 = new ofxUICanvas(subGUIRect);
	gui3->setVisible(false);

	int startX = 217;
	int startY = 193;
	int padW = 112;
	int padH = 76;
	int pngWidth = 103;
	int toggleWidth = 214;
	
//	gui3->addWidget(new ofxUILabel(0,0, "GUI3", "GUI3", OFX_UI_FONT_LARGE));
	
	ofxUIMultiImageToggle* toggle = new ofxUIMultiImageToggle(startX,startY, toggleWidth, 52, false, "GUI/images/button.png","ZONE3_CURTAIN");
	toggle->setLabelVisible(false);
	gui3->addWidget(toggle);
	
	toggle = new ofxUIMultiImageToggle(startX,startY+padH, toggleWidth, 52, false, "GUI/images/button.png","ZONE3_LIGHT");
	toggle->setLabelVisible(false);
	gui3->addWidget(toggle);

	ofxUIButton*button = new ofxUIButton("Z3_READY",false,toggleWidth, 52,readyButtonPoint.x,readyButtonPoint.y);
	button->setLabelVisible(false);
	gui3->addWidget(button);
	
	ofAddListener(gui3->newGUIEvent,this,&testApp::guiEvent);
}//--------------------------------------------------------------
void testApp::setGUI4(){
	
	scroll = new MyScrollview(304,276,400,301);
	ofAddListener(scroll->newGUIEvent,this,&testApp::scrollEvent);
	gui4 = new ofxUICanvas(subGUIRect);
	gui4->setVisible(false);
	
	int startX = 187;
	int startY = 479;
	int padW = 112;
	int padH = 76;
	int pngWidth = 103;

	int toggleWidth = 214;
	
	ofxUIButton *button = new ofxUIButton("BUTTON_UP", false, scroll->rect.getWidth(), 61,0,0);
	button->setLabelVisible(true);
	gui4->addWidget(button);
	
	
	button = new ofxUIButton("BUTTON_DOWN", false, scroll->rect.getWidth(), 61,0,scroll->rect.getHeight()+61);
	button->setLabelVisible(true);
	gui4->addWidget(button);
	
	ofxUIMultiImageToggle* toggle = new ofxUIMultiImageToggle(startX,startY, toggleWidth, 52, false, "GUI/images/button.png","ZONE4_LIGHT");
	toggle->setLabelVisible(false);
	gui4->addWidget(toggle);
	
	toggle = new ofxUIMultiImageToggle(startX,startY+padH, toggleWidth, 52, false, "GUI/images/button.png","ZONE4_DOOR");
	toggle->setLabelVisible(false);
	gui4->addWidget(toggle);

	
	
	button = new ofxUIButton("Z4_READY",false,toggleWidth, 52,readyButtonPoint.x,readyButtonPoint.y);
	button->setLabelVisible(false);
	gui4->addWidget(button);
	
	ofAddListener(gui4->newGUIEvent,this,&testApp::guiEvent);
}//--------------------------------------------------------------
void testApp::setGUI5(){
	
	gui5 = new ofxUICanvas(subGUIRect);
	
	
	int startX = 217;
	int startY = 193;
	int padW = 112;
	int padH = 76;
	int pngWidth = 103;
	int toggleWidth = 214;
	
	ofxUIMultiImageToggle* toggle = new ofxUIMultiImageToggle(startX,startY, toggleWidth, 52, false, "GUI/images/button.png","ZONE5_LIGHT");
	toggle->setLabelVisible(false);
	gui5->addWidget(toggle);
	

	
	ofxUIButton*button = new ofxUIButton("Z5_READY",false,toggleWidth, 52,readyButtonPoint.x,readyButtonPoint.y);
	button->setLabelVisible(false);
	gui5->addWidget(button);
	
	gui5->setVisible(false);
	ofAddListener(gui5->newGUIEvent,this,&testApp::guiEvent);
	
}


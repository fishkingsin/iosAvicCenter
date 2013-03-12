#include "testApp.h"
#include "Settings.h"
//--------------------------------------------------------------
void testApp::setup(){
	subGUIRect.set(228,140,535,883);
	// initialize the accelerometer
	ofxAccelerometer.setup();
	ofSetLogLevel(OF_LOG_VERBOSE);
	
	//If you want a landscape oreintation
	//iPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
	
	ofBackground(127,127,127);
	
	setGUI1();
	setGUI2();
    setGUI3();
    setGUI4();
    setGUI5();
	
    gui1->setDrawBack(false);
    gui2->setDrawBack(false);
    gui3->setDrawBack(false);
    gui4->setDrawBack(false);
	gui5->setDrawBack(false);
	backgrounds.push_back(ofImage("GUI/images/background01.png"));
	backgrounds.push_back(ofImage("GUI/images/background02.png"));
	backgrounds.push_back(ofImage("GUI/images/background03.png"));
	backgrounds.push_back(ofImage("GUI/images/background04.png"));
	
	port = Settings::getInt("Port" , 2838);
    host = Settings::getString("Host" , "192.168.6.133");
	
	weConnected = tcpClient.setup(host,port);
	//optionally set the delimiter to something else.  The delimter in the client and the server have to be the same
	tcpClient.setMessageDelimiter("\n");
	
	connectTime = 0;
	deltaTime = 0;
	
	tcpClient.setVerbose(true);
	
	
}
void testApp::exit()
{
	delete gui1;
	delete gui2;
    delete gui3;
    delete gui4;
}
void testApp::scrollEvent(MyScrollViewEventArgs &e)
{
	ofLogVerbose() << "scrollEvent: " << "Index: " << e.index;
	tcpClient.send("ZONE_4_MAIN_"+ofToString(e.index));
}
//--------------------------------------------------------------
void testApp::guiEvent(ofxUIEventArgs &e)
{
	string name = e.widget->getName();
	int kind = e.widget->getKind();
	ofLogVerbose() << "got event from: " << name << " kind " << kind << endl;
	if(name == "ZONE2")
	{
		((ofxUIToggle*)gui1->getWidget("ZONE3"))->setValue(false);
		((ofxUIToggle*)gui1->getWidget("ZONE4"))->setValue(false);
		((ofxUIToggle*)gui1->getWidget("ZONE5"))->setValue(false);
		gui2->setVisible(true);
		gui3->setVisible(false);
		gui4->setVisible(false);
		gui5->setVisible(false);
//		scroll->setVisible(gui5->isVisible());
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
//		scroll->setVisible(gui5->isVisible());
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
		scroll->reset();
//		scroll->setVisible(gui5->isVisible());
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
//		scroll->setVisible(gui5->isVisible());
	}
	if(name == "SCROLLABLE"){
		ofLogVerbose(name)<<e.widget->getRect()->getPosition().y;
		
	}
	if(name == "BUTTON_UP"){
		if(!((ofxUIButton*)e.widget)->getValue())
		{
			scroll->prevItem();
			ofLogVerbose(name)<<e.widget->getRect()->getPosition().y;
		}
//		scroll->mousePressed(ofRandom(subGUIRect.x,subGUIRect.x+subGUIRect.width), ofRandom(subGUIRect.y,subGUIRect.y+subGUIRect.height), 0);
//		scroll->mouseDragged(ofRandom(subGUIRect.x,subGUIRect.x+subGUIRect.width), ofRandom(subGUIRect.y,subGUIRect.y+subGUIRect.height), 0);
//		scroll->mouseReleased(ofRandom(subGUIRect.x,subGUIRect.x+subGUIRect.width), ofRandom(subGUIRect.y,subGUIRect.y+subGUIRect.height), 0);
		
	}
	if(name == "BUTTON_DOWN"){
		if(!((ofxUIButton*)e.widget)->getValue())
		{
			scroll->nextItem();
		ofLogVerbose(name)<<e.widget->getRect()->getPosition().y;
		}
		
	}
	if(name == "RESET_ALL")
	{
		tcpClient.send(name);
	}

	
}
//--------------------------------------------------------------
void testApp::update(){
	if(weConnected){
		
		
		if(!tcpClient.isConnected()){
			weConnected = false;
		}
	}else{
		//if we are not connected lets try and reconnect every 5 seconds
		deltaTime = ofGetElapsedTimeMillis() - connectTime;
		
		if( deltaTime > 5000 ){
			weConnected = tcpClient.setup(host,port);
			connectTime = ofGetElapsedTimeMillis();
		}
		
	}
}

//--------------------------------------------------------------
void testApp::draw(){
//	ofBackground(255);
	if(gui2->isVisible())backgrounds[0].draw(0, 0);
	if(gui3->isVisible())backgrounds[1].draw(0, 0);
	if(gui4->isVisible())backgrounds[2].draw(0, 0);
	if(gui5->isVisible())backgrounds[3].draw(0, 0);
	//	background.draw(0,0);
	if (gui4->isVisible()) {
		scroll->draw();
	}
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
	
}

//--------------------------------------------------------------
void testApp::gotFocus(){
	
}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){
	
}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){
	
}
//--------------------------------------------------------------
void testApp::setGUI1(){
	float dim = 225;
	float dim_h = 55;
	float xInit = OFX_UI_GLOBAL_WIDGET_SPACING;
    float length = 231+xInit;
	
	gui1 = new ofxUICanvas(0,180, length+xInit, ofGetHeight());


	ofxUIToggle *toggle;
//	ofxUIMultiImageToggle *btn;
	toggle = new ofxUIToggle("ZONE2", false, dim, dim_h,0,0);
//	btn = new ofxUIMultiImageToggle(dim, dim_h, false, "GUI/images/button01.png", "ZONE2");
	toggle->setLabelVisible(false);
	toggle->setValue(true);
	gui1->addWidget(toggle);
	toggle = new ofxUIToggle("ZONE3", false, dim, dim_h,0,(dim_h+10));
//	btn = new ofxUIMultiImageToggle(dim, dim_h, false, "GUI/images/button02.png", "ZONE3");
	toggle->setLabelVisible(false);
	gui1->addWidget(toggle);
		toggle = new ofxUIToggle("ZONE4", false, dim, dim_h,0,(dim_h+10)*2);
//	btn = new ofxUIMultiImageToggle(dim, dim_h, false, "GUI/images/button03.png", "ZONE4");
	toggle->setLabelVisible(false);
	gui1->addWidget(toggle);
		toggle = new ofxUIToggle("ZONE5", false, dim, dim_h,0,(dim_h+10)*3);
//	btn = new ofxUIMultiImageToggle(dim, dim_h, false, "GUI/images/button04.png", "ZONE5");
	toggle->setLabelVisible(false);
	gui1->addWidget(toggle);
	ofxUIButton* button = new ofxUIButton("RESET_ALL", false, 150,100,42,635);
	gui1->addWidget(button);
	button->setLabelVisible(false);
	
	
	
	ofAddListener(gui1->newGUIEvent,this,&testApp::guiEvent);
}
//--------------------------------------------------------------
void testApp::setGUI2(){

	
	gui2 = new ofxUICanvas(subGUIRect);
	gui2->setVisible(true);
		gui2->addWidgetDown(new ofxUILabel("PANEL ZONE2", OFX_UI_FONT_LARGE));
	
	
	ofAddListener(gui2->newGUIEvent,this,&testApp::guiEvent);
}//--------------------------------------------------------------
void testApp::setGUI3(){

	
	gui3 = new ofxUICanvas(subGUIRect);
	gui3->setVisible(false);
		gui3->addWidgetDown(new ofxUILabel("PANEL ZONE3", OFX_UI_FONT_LARGE));
	ofAddListener(gui3->newGUIEvent,this,&testApp::guiEvent);
}//--------------------------------------------------------------
void testApp::setGUI4(){

	scroll = new MyScrollview(303,408,399,301);
	ofAddListener(scroll->newGUIEvent,this,&testApp::scrollEvent);
	gui4 = new ofxUICanvas(303,230,399,722);
	
	ofxUIToggle * togle = new ofxUIToggle("Z4_START", false, scroll->rect.getWidth(), 61);
	togle->setLabelVisible(false);
	gui4->addWidget(togle);
	gui4->setVisible(false);
	
	
	ofxUIButton *button = new ofxUIButton("BUTTON_UP", false, scroll->rect.getWidth(), 61,0,113);
	button->setLabelVisible(false);
	gui4->addWidget(button);
	
	
	button = new ofxUIButton("BUTTON_DOWN", false, scroll->rect.getWidth(), 61,0,113+scroll->rect.getHeight()+61);
	button->setLabelVisible(false);
	gui4->addWidget(button);
	
	ofAddListener(gui4->newGUIEvent,this,&testApp::guiEvent);
}//--------------------------------------------------------------
void testApp::setGUI5(){

//	scroll = new MyScrollview(303,408,399,301);
	gui5 = new ofxUICanvas(subGUIRect);
//	gui5->addWidgetDown(new ofxUILabel("PANEL ZONE5", OFX_UI_FONT_LARGE));
//	ofxUIButton * button = new ofxUIButton("BUTTON_UP", false, scroll->rect.getWidth(), 61,scroll->rect.getX(),0);
//	button->setLabelVisible(false);
//	
//	gui5->addWidget(button);
//	
//
//	button = new ofxUIButton("BUTTON_DOWN", false, scroll->rect.getWidth(), 61,scroll->rect.getX(),scroll->rect.getY()+scroll->rect.getHeight());
//	button->setLabelVisible(false);
//	
//	gui5->addWidget(button);

	gui5->setVisible(false);
	ofAddListener(gui5->newGUIEvent,this,&testApp::guiEvent);

}

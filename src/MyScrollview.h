//
//  MyScrollview.h
//  ShowControl
//
//  Created by james KONG on 11/3/13.
//
//

#ifndef ShowControl_MyScrollview_h
#define ShowControl_MyScrollview_h
#include "ofxUI.h"
#include "ofxAnimatableFloat.h"
#include "ofxTrueTypeFontUC.h"
#define DURATION 1
class MyScrollViewEventArgs : public ofEventArgs
{
public:
	int index;
};
class MyScrollview {
public:
	MyScrollview(float x, float y, float w, float h)
    {
		//		ofxUICanvas(x,y,w,h);
		rect.set(x,y,w,h);
        initScrollable();
    }
	void initScrollable()
	{
		
		ofAddListener(ofEvents().update, this, &MyScrollview::update);
		currentPageX.setRepeatType(PLAY_ONCE);
		currentPageX.setCurve(EASE_OUT);
		currentPageX.setDuration(DURATION);
		
		fontsize = 18;
		font.loadFont("GUI/NewMedia Fett.ttf", fontsize);
		fbo.allocate( rect.width,rect.height);
		
		ofBuffer items_buffer = ofBufferFromFile("items.txt");
		items = ofSplitString(items_buffer.getText(),"\n");
		
//		ofLogVerbose() <<"items_buffer " << items_buffer.getText();
//		for(int i = 0  ; i < items.size() ; i++)
//		{
//			ofLogVerbose() <<"items "<< i << " : " << items[i];
//		}
//		for(int i = 0  ; i < items.size()  ; i++)
//		{
//			string st = items[i];
//			items.push_back(st);
//		}
		
		hightLightIdx = 0;
		itemHeight = fontsize+10;
		canNotMoreThen = (fbo.getHeight()/itemHeight)*0.45;
		pos.set(0,0);
	}
	void reset()
	{
		hightLightIdx = 0;
		pos.set(0,0);
		
		currentPageX.animateTo(pos.y);
		currentPageX.update(100);
		MyScrollViewEventArgs arg;
		arg.index = hightLightIdx;
		ofNotifyEvent(newGUIEvent, arg);
	}
	void nextItem()
	{
		if(hightLightIdx<items.size()-1)
		{
			hightLightIdx++;
			if(hightLightIdx>canNotMoreThen && hightLightIdx<items.size()-canNotMoreThen-1)
				//			if(pos.y-itemHeight <= 0 && hightLightIdx<items.size()-canNotMoreThen)
			{
				pos.y-=itemHeight;
				currentPageX.animateTo(pos.y);
			}
			//			else if(hightLightIdx==canNotMoreThen)
			//			{
			//				pos.y-=itemHeight*hightLightIdx;
			//				currentPageX.animateTo(pos.y);
			//			}
		}
		MyScrollViewEventArgs arg;
		arg.index = hightLightIdx;
		ofNotifyEvent(newGUIEvent, arg);
	}
	void prevItem()
	{
		if(hightLightIdx>0)
		{
			hightLightIdx--;
			if(hightLightIdx>canNotMoreThen && hightLightIdx<items.size()-canNotMoreThen-1)
				//			if(pos.y+itemHeight <= 0 && hightLightIdx<items.size()-canNotMoreThen)
			{
				pos.y+=itemHeight;
				currentPageX.animateTo(pos.y);
			}
			else if(hightLightIdx <= canNotMoreThen)
			{
				pos.y=0;
				currentPageX.animateTo(pos.y);
			}
		}
		MyScrollViewEventArgs arg;
		arg.index = hightLightIdx;
		ofNotifyEvent(newGUIEvent, arg );
	}
	void update(ofEventArgs& args)
	{
		float dt = 1.0f / ofGetFrameRate();
		currentPageX.update(dt);
	}
	void draw()
	{
		ofEnableAlphaBlending();
		fbo.begin();
		ofClear(0);
		//		ofxUIScrollableCanvas::draw();
		ofPushMatrix();
		ofTranslate(0,currentPageX.getCurrentValue());
		
		for(int i = 0 ;i < items.size(); i++)
		{
			if(hightLightIdx==i)
			{
				ofPushStyle();
				ofFill();
				
				
				ofSetColor(255 ,125);
				ofRect(0,(i*itemHeight),rect.width,itemHeight);
				ofPopStyle();
			}
			ofPushStyle();
			
				ofSetColor(255);
			ofPushMatrix();
			ofPushStyle();
//			ofScale(0.5,0.5);
			font.drawString(ofToString(i),0,(i*itemHeight)+itemHeight);
			ofPopStyle();
			ofPopMatrix();
			ofRectangle _rect =  font.getStringBoundingBox(items[i], 0, 0);
			font.drawString(items[i], rect.width*0.5-_rect.width*0.5, (i*itemHeight)+itemHeight );
			ofPopStyle();
		}
		ofPopMatrix();
		fbo.end();
		fbo.draw(rect.x,rect.y,rect.width,rect.height);
	}
	ofFbo fbo;
	ofRectangle rect;
	vector < string > items;
	int hightLightIdx,itemHeight;
	int fontsize;
	ofPoint pos;
	ofxTrueTypeFontUC font;
	ofxAnimatableFloat currentPageX;
	int canNotMoreThen;
	ofEvent<MyScrollViewEventArgs> newGUIEvent;
};

#endif

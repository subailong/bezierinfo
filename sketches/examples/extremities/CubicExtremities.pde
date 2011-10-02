// Dependencies are in the "common" directory
// © 2011 Mike "Pomax" Kamermans of nihongoresources.com

ViewPort main, cx, cy;
Point[] points;
int boxsize = 200;

// REQUIRED METHOD
void setup()
{
	size(800,boxsize+100);
	noLoop();
	setupPoints();
	setupViewPorts();
	text("",0,0);
}

/**
 * Set up four points, to form a cubic curve
 */
void setupPoints()
{
	points = new Point[4];
	points[0] = new Point(25,65);
	points[1] = new Point(155,20);
	points[2] = new Point(20,200);
	points[3] = new Point(150,130);
}


/**
 * Set up three 'view ports', because we'll be drawing three different things
 */
void setupViewPorts()
{
	main = new ViewPort(50+0,50+0,boxsize,boxsize);
	cx = new ViewPort(50+250,50+0,boxsize,boxsize);
	cy = new ViewPort(50+500,50+0,boxsize,boxsize);
}

// REQUIRED METHOD
void draw()
{
	noFill();
	stroke(0);
	background(255);
	drawViewPorts();
	drawCurves();
	drawDerivativeRoots();
	drawExtras();
}

/**
 * Draw all the viewport graphics
 * (axes, labels, numbering, etc)
 */
void drawViewPorts()
{
	main.drawLine(0,0,0,main.height,  0,0,0,255);
	main.drawLine(0,0,main.width,0,  0,0,0,255);
	main.drawText("Full curve", 0,-15, 0,0,0,255);

	cx.drawText("Only f(t) for X coordinates", -20,-25, 0,0,0,255);
	cx.drawText("t →", 100,-5, 0,0,0,255);
	cx.drawText("0", -2,-10, 0,0,0,255);
	cx.drawLine(0,0,0,main.height,  0,0,0,255);
	cx.drawText("1", main.width-4,-8, 0,0,0,255);
	cx.drawLine(0,0,main.width,0,  0,0,0,255);
	cx.drawLine(0,0,0,-5,  0,0,0,255);
	cx.drawLine(main.width,0,main.width,-5,  0,0,0,255);
	cx.drawText("X ↓", -20,130, 0,0,0,255);

	cy.drawText("Only f(t) for Y coordinates", -20,-25, 0,0,0,255);
	cy.drawText("t →", 100,-5, 0,0,0,255);
	cy.drawText("0", -2,-10, 0,0,0,255);
	cy.drawLine(0,0,0,main.height,  0,0,0,255);
	cy.drawText("1", main.width-4,-8, 0,0,0,255);
	cy.drawLine(0,0,main.width,0,  0,0,0,255);
	cy.drawLine(0,0,0,-5,  0,0,0,255);
	cy.drawLine(main.width,0,main.width,-5,  0,0,0,255);
	cy.drawText("Y ↓", -20,130, 0,0,0,255);
}

/**
 * Run through the entire interval [0,1] for 't', and generate
 * the corresponding fx(t) and fy(t) values at each 't' value.
 * Then draw those as points in three places: once as mixed
 * parametric curve, and twice as component single curves
 */
void drawCurves()
{
	double range = 200;
	for(float t = 0; t<1.0; t+=1.0/range) {
		double x = computeCubicBaseValue(t, points[0].getX(), points[1].getX(), points[2].getX(), points[3].getX());
		double y = computeCubicBaseValue(t, points[0].getY(), points[1].getY(), points[2].getY(), points[3].getY());
		main.drawPoint(x,y, 0,0,0,255); 
		cx.drawPoint(t*range, x, 0,0,0,255);
		cy.drawPoint(t*range, y, 0,0,0,255);
	}
}

/**
 * Draw the derivative roots for the component curves, if they have any
 */
void drawDerivativeRoots()
{
  {double[] ts = computeCubicFirstDerivativeRoots(points[0].getX(), points[1].getX(), points[2].getX(), points[3].getX());
	for(int i=0; i<ts.length;i++) {
		double t = ts[i];
		if(t>=0 && t<=1) {
			double x = computeCubicBaseValue(t, points[0].getX(), points[1].getX(), points[2].getX(), points[3].getX());
			double y = computeCubicBaseValue(t, points[0].getY(), points[1].getY(), points[2].getY(), points[3].getY());
			cx.drawEllipse(boxsize*t,x,5,5, 255,0,0,255); 
			cx.drawLine(boxsize*t,0,boxsize*t,x, 255,0,0,100); 
			main.drawEllipse(x,y,5,5, 255,0,0,255);  }}}

  {double[] ts = computeCubicFirstDerivativeRoots(points[0].getY(), points[1].getY(), points[2].getY(), points[3].getY());
	for(int i=0; i<ts.length;i++) {
		double t = ts[i];
		if(t>=0 && t<=1) {
			double x = computeCubicBaseValue(t, points[0].getX(), points[1].getX(), points[2].getX(), points[3].getX());
			double y = computeCubicBaseValue(t, points[0].getY(), points[1].getY(), points[2].getY(), points[3].getY());
			cy.drawEllipse(boxsize*t,y,5,5, 255,0,255,255); 
			cy.drawLine(boxsize*t,0,boxsize*t,y, 255,0,255,100); 
			main.drawEllipse(x,y,5,5, 255,0,255,255); }}}
}

/**
 * For nice visuals, make the curve's fixed points stand out,
 * and draw the lines connecting the start/end and control point.
 * Also, we label each coordinate with its x/y value, for clarity.
 */
void drawExtras()
{
	showPointsInViewPort(points,main);
	stroke(0,75);
	main.drawLine(points[0].getX(), points[0].getY(), points[1].getX(), points[1].getY(), 0,0,0,75);
	main.drawLine(points[2].getX(), points[2].getY(), points[3].getX(), points[3].getY(), 0,0,0,75);
}
%% initialization
initialization();

%% main (robot program here)
motor(100,100);
wait(1);
motor(-100,100);
wait(1);
motor(100,100);
wait(1);

%% visualization
saveflag = true;
visualize(saveflag);

%% Functions (DO NOT edit)
function initialization()
    clear
    close all

    global x0 y0 theta0
    x0 = 0;
    y0 = 0;
    theta0 = pi/2;

    global goal1 goal2
    goal1 = [0,1];
    goal2 = [1,1];

    global dt
    dt = 1/24;

    global x y theta
    x = x0;
    y = y0;
    theta = theta0;

    global xout yout thetaout
    xout = x;
    yout = y;
    thetaout = theta;
end
function motor(right,left)
	global vel omega
	vel = 0.01*(right + left) / 2;
	omega = 0.01*(right - left) / 2;
end

function wait(time)
	global x y theta xout vel omega dt xout yout thetaout
	for i = 1:(time/dt)
		x = x + vel*cos(theta)*dt;
		y = y + vel*sin(theta)*dt;
		theta = theta + omega*dt;
		xout = [xout; x];
		yout = [yout; y];
		thetaout = [thetaout; theta];
	end
end

function visualize(saveflag)
	global x0 y0 goal1 goal2 xout yout thetaout
	figure;
	plot(x0,y0,'bo');
	hold on
	plot(goal1(1),goal1(2),'ro');
	hold on;
	plot(goal2(1),goal2(2),'ro');
	axis square;
	axis([-1 2 -1 2]);

	robot_length = 0.2;
	robot_width = 0.1;
	robot_shape = [0.5*robot_length, 0.5*robot_width;...
		-0.5*robot_length, 0.5*robot_width;...
		-0.5*robot_length, -0.5*robot_width;...
		0.5*robot_length, -0.5*robot_width]';
	robot_attitude = [cos(thetaout(1)), -sin(thetaout(1)); sin(thetaout(1)), cos(thetaout(1))]*robot_shape;
	robot_place = robot_attitude + [xout(1), yout(1); xout(1) yout(1); xout(1), yout(1); xout(1), yout(1)]';
	robot_line1 = line([robot_place(1,1), robot_place(1,2)],[robot_place(2,1), robot_place(2,2)]);
	robot_line2 = line([robot_place(1,2), robot_place(1,3)],[robot_place(2,2), robot_place(2,3)]);
	robot_line3 = line([robot_place(1,3), robot_place(1,4)],[robot_place(2,3), robot_place(2,4)]);
	robot_line4 = line([robot_place(1,4), robot_place(1,1)],[robot_place(2,4), robot_place(2,1)]);
	F = getframe(gcf);
	for i = 1:length(xout)
		% draw rectangle robot at (x,y) with angle theta
		robot_attitude = [cos(thetaout(i)), -sin(thetaout(i)); sin(thetaout(i)), cos(thetaout(i))]*robot_shape;
		robot_place = robot_attitude + [xout(i), yout(i); xout(i) yout(i); xout(i), yout(i); xout(i), yout(i)]';
		robot_line1.XData = [robot_place(1,1), robot_place(1,2)];
		robot_line1.YData = [robot_place(2,1), robot_place(2,2)];
		robot_line2.XData = [robot_place(1,2), robot_place(1,3)];
		robot_line2.YData = [robot_place(2,2), robot_place(2,3)];
		robot_line3.XData = [robot_place(1,3), robot_place(1,4)];
		robot_line3.YData = [robot_place(2,3), robot_place(2,4)];
		robot_line4.XData = [robot_place(1,4), robot_place(1,1)];
		robot_line4.YData = [robot_place(2,4), robot_place(2,1)];
		drawnow;
		F = [F, getframe(gcf)];
		% pause(0.1);
	end

	% save video as mp4 file
	if saveflag
		videoobj = VideoWriter("egadget_beginner", 'MPEG-4');
		fprintf('video saving...')
		open(videoobj);
		writeVideo(videoobj, F);
		close(videoobj);
		fprintf('complete!\n');
	end
end
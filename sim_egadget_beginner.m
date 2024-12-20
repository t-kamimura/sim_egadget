% sim_egadget_beginner
% Original version is written by Tomoya KAMIMURA
% Robot simulator for moon landing mission

%% initialization
initialization();

%% main (robot program here)
motor(50,50);
wait(2);
motor(50,-50);
wait(pi/10);
motor(50,50);
wait(2);

%% visualization
saveflag = true;
save_video(saveflag);

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
    dt = 0.5*1/24;

    global t x y theta
    x = x0;
    y = y0;
    theta = theta0;

    figure;
	plot(x0,y0,'bo');
	hold on
	plot(goal1(1),goal1(2),'ro');
	hold on;
	plot(goal2(1),goal2(2),'ro');
	axis square;
	axis([-1 2 -1 2]);

	global robot_shape robot_sensorshape robot_attitude robot_place robot_sensoratt robot_sensorpos

	robot_length = 0.2;
	robot_width = 0.1;
	robot_shape = [0.5*robot_length, 0.5*robot_width;...
		-0.5*robot_length, 0.5*robot_width;...
		-0.5*robot_length, -0.5*robot_width;...
		0.5*robot_length, -0.5*robot_width]';
	robot_sensorshape = [0.35*robot_length, 0]';
	robot_attitude = [cos(theta), -sin(theta); sin(theta), cos(theta)]*robot_shape;
	robot_place = robot_attitude + [x, y; x y; x, y; x, y]';
	robot_sensoratt = [cos(theta), -sin(theta); sin(theta), cos(theta)]*robot_sensorshape;
	robot_sensorpos = robot_sensoratt + [x, y]';

	global robot_line1 robot_line2 robot_line3 robot_line4 robot_ballsensor F
	robot_line1 = line([robot_place(1,1), robot_place(1,2)],[robot_place(2,1), robot_place(2,2)]);
	robot_line2 = line([robot_place(1,2), robot_place(1,3)],[robot_place(2,2), robot_place(2,3)]);
	robot_line3 = line([robot_place(1,3), robot_place(1,4)],[robot_place(2,3), robot_place(2,4)]);
	robot_line4 = line([robot_place(1,4), robot_place(1,1)],[robot_place(2,4), robot_place(2,1)]);
	robot_ballsensor = plot(robot_sensorpos(1), robot_sensorpos(2), 'ko', 'MarkerSize', 3, 'MarkerEdgeColor','k','MarkerFaceColor','k');
	F = getframe(gcf);
end

function motor(left,right)
	global vel omega
	if right > 100
		right = 100;
	elseif right < -100
		right = -100;
	end
	if left > 100
		left = 100;
	elseif left < -100
		left = -100;
	end
	vel = 0.01*(right + left) / 2;
	omega = 0.1*(right - left) / 2;
end

function wait(time)
	global t x y theta vel omega dt
	global robot_shape robot_sensorshape robot_attitude robot_place robot_sensoratt robot_sensorpos
	global robot_line1 robot_line2 robot_line3 robot_line4 robot_ballsensor F
	
	for i = 1:(time/dt)
        t = t + dt;
		x = x + vel*cos(theta)*dt;
		y = y + vel*sin(theta)*dt;
		theta = rem(theta + omega*dt, 2*pi);
		if theta > pi
			theta = theta - 2*pi;
		elseif theta < -pi
			theta = theta + 2*pi;
		end

		% visualize
		robot_attitude = [cos(theta), -sin(theta); sin(theta), cos(theta)]*robot_shape;
		robot_place = robot_attitude + [x, y; x y; x, y; x, y]';
		robot_sensoratt = [cos(theta), -sin(theta); sin(theta), cos(theta)]*robot_sensorshape;
		robot_sensorpos = robot_sensoratt + [x, y]';
		robot_line1.XData = [robot_place(1,1), robot_place(1,2)];
		robot_line1.YData = [robot_place(2,1), robot_place(2,2)];
		robot_line2.XData = [robot_place(1,2), robot_place(1,3)];
		robot_line2.YData = [robot_place(2,2), robot_place(2,3)];
		robot_line3.XData = [robot_place(1,3), robot_place(1,4)];
		robot_line3.YData = [robot_place(2,3), robot_place(2,4)];
		robot_line4.XData = [robot_place(1,4), robot_place(1,1)];
		robot_line4.YData = [robot_place(2,4), robot_place(2,1)];
		robot_ballsensor.XData = robot_sensorpos(1);
		robot_ballsensor.YData = robot_sensorpos(2);
		drawnow;


		if mod(i,2) == 1
			F = [F, getframe(gcf)];
		end
	end
end

function save_video(saveflag)
	global F
	% save video as mp4 file
	if saveflag
		videoobj = VideoWriter("egadget_beginner2", 'MPEG-4');
		fprintf('video saving...')
		open(videoobj);
		writeVideo(videoobj, F);
		close(videoobj);
		fprintf('complete!\n');
	end
end
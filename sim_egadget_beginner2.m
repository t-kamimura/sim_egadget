% sim_egadget_beginner2
% Original version is written by Tomoya KAMIMURA
% Robot simulator for very first soccor mission
%
% NOTE=============================================
% 無条件ループにするとMATLABが終わらないので，
% シミュレーション時間上限(maxtime)を決めています
% ボールを蹴ったらロボットはその場で止まります
% =================================================

%% initialization (Do NOT edit)
clear
initialization();
global ch1 t maxtime

%% main (robot program here)
while(t < maxtime)
    if ch1 < 30
        motor(-50,50);
        wait(0.1);
    else
        motor(52,50);
        wait(0.1);
    end
end

%% visualization
saveflag = true;
save_video(saveflag);

%% Functions (DO NOT edit)
function initialization()
    close all

    global x0 y0 theta0
    x0 = 0;
    y0 = 0;
    theta0 = 0;

    global ball
    ball = [0,1];

    global dt maxtime
    dt = 0.5*1/24;
	maxtime = 10;

    global t x y theta ch1
    t = 0;
    x = x0;
    y = y0;
    theta = theta0;
	ch1 = 0;

	figure;
    % initial position
	plot(x0,y0,'ko');
	hold on
    % target ball
	plot(ball(1),ball(2),'o','MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',6);
	axis square;
	axis([-1.5 1.5 -1 2]);

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

	global robot_line1 robot_line2 robot_line3 robot_line4 robot_ballsensor sensor_monitor time_monitor F
	robot_line1 = line([robot_place(1,1), robot_place(1,2)],[robot_place(2,1), robot_place(2,2)]);
	robot_line2 = line([robot_place(1,2), robot_place(1,3)],[robot_place(2,2), robot_place(2,3)]);
	robot_line3 = line([robot_place(1,3), robot_place(1,4)],[robot_place(2,3), robot_place(2,4)]);
	robot_line4 = line([robot_place(1,4), robot_place(1,1)],[robot_place(2,4), robot_place(2,1)]);
	robot_ballsensor = plot(robot_sensorpos(1), robot_sensorpos(2), 'ko', 'MarkerSize', 3, 'MarkerEdgeColor','k','MarkerFaceColor','k');
	time_monitor = text(0.5, 1.7, ['time: ', num2str(t)],"FontSize", 10);
	sensor_monitor = text(0.5, 1.5,  ['ch1:', num2str(ch1)],"FontSize", 10);
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
	global t x y theta vel omega ch1 dt ball maxtime
	global robot_shape robot_sensorshape robot_attitude robot_place robot_sensoratt robot_sensorpos
	global robot_line1 robot_line2 robot_line3 robot_line4 robot_ballsensor F
	global sensor_monitor time_monitor

    % simulating sensor reaction
	dist = sqrt((x - ball(1))^2 + (y - ball(2))^2);
	arg = atan2(ball(2) - y, ball(1) - x);

	if dist < 1.5 && abs(theta - arg) < pi/6
		ch1 = round((1.5-dist)*100/2 + abs(theta - arg)*50/pi);
	else
		ch1 = 0;
    end

	for i = 1:(time/dt)
        % simulating robot movement
        t = t + dt;
        if t < maxtime && dist > 0.1
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
		    time_monitor.String = ['time: ', num2str(t)];
		    sensor_monitor.String = ['ch1: ', num2str(ch1)];
		    drawnow;

		    if mod(i,2) == 1
			    F = [F, getframe(gcf)];
            end
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
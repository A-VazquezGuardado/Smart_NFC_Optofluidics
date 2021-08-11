addpath('D:\Dropbox\NWpostdoc\Research\11_(Yixin)Microfluidics\210104_total\tracking_codes') 
addpath('C:\Users\Jimmy\Dropbox\NWpostdoc\Research\11_(Yixin)Microfluidics\210104_total\tracking_codes')
load('traj.mat')

j=0;
for i=1:length(traj)
    if length(traj(i).x)>10 && min(traj(i).u>0)
    theta = -0.8; % to rotate 90 counterclockwise
    R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
    p=R*[traj(i).x traj(i).y]';
    v=R*[traj(i).u traj(i).v]';
    a=R*[traj(i).ax traj(i).ay]';
    j=j+1;
    trajf(j)=traj(i);
    trajf(j).x=p(1,:);
    trajf(j).y=p(2,:);
    trajf(j).u=v(1,:);
    trajf(j).v=v(2,:);
    trajf(j).ax=a(1,:);
    trajf(j).ay=a(2,:);    
    end
end

% plot_long_trajectories(traj(2000:13000),1)
% colormap(jet)
% colorbar
% caxis([0 22000])
% view([0 0 1])
% %axis equal
% grid off
% %axis equal
% axis([-50 550 0 45])

plot_long_trajectories(trajf(1:4000),1)
colormap(jet)
colorbar
caxis([0 18000])
view([0 0 1])
%axis equal
grid off
%axis equal
axis([-50 550 0 45])

axis([400 500 0 45])


scatter_t=traj2scatter_t(trajf)
%grid data
f=1/640;
for i=1:round(length(scatter_t)*(f*10))-1
scatter_tc(i).x=[];
scatter_tc(i).y=[];
scatter_tc(i).u=[];
scatter_tc(i).v=[];
scatter_tc(i).ax=[];
scatter_tc(i).ay=[];
    for j=1:1/(f*10)
scatter_tc(i).x=[scatter_tc(i).x; scatter_t((i-1)/(f*10)+j).x];
scatter_tc(i).y=[scatter_tc(i).y; scatter_t((i-1)/(f*10)+j).y];
scatter_tc(i).u=[scatter_tc(i).u; scatter_t((i-1)/(f*10)+j).u];
scatter_tc(i).v=[scatter_tc(i).v; scatter_t((i-1)/(f*10)+j).v];
scatter_tc(i).ax=[scatter_tc(i).ax; scatter_t((i-1)/(f*10)+j).ax];
scatter_tc(i).ay=[scatter_tc(i).ay; scatter_t((i-1)/(f*10)+j).ay];
    end
    i
end

%every time index is 0.1s
    
[xg,yg,ug,vg]=scatter_t2grid2D(scatter_tc, 0, 2, 500, 0, 2, 40);

%contour
ugf=nanmean(ug(:,:,10:17*10),3);
vgf=nanmean(vg(:,:,10:17*10),3);

figure
hold on
[c,h]=contourf(xg,yg,ugf,100);
set(gca,'FontSize',15);
set(h,'LineColor','none');
caxis([0 25000])
colormap(jet)
colorbar
axis equal
axis([400 500 0 45])
box on
h=quiver(xg,yg,ugf./4000,vgf./4000,0,'k','linewidth',1.5);


theta=2
R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];

figure
hold on
for i=1:5   %i=420,440,460,480,500
    ugp(i,:)=ugf(210+10*(i-1),2:end)./max(ugf(210+10*(i-1),2:end));
    yyg=yg(210+10*(i-1),2:end)./35*30;
plot(yyg,ugp(i,:),'LineWidth',2)
end
axis([0 30 0.4 1])
x=1:100;
x=x./100*35-17.25;
figure
plot (x(10:90)+15,1-x(10:90).^2/17.25^2)


csvwrite('u420.txt', [yyg' ugp(1,:)']);
csvwrite('u440.txt', [yyg' ugp(2,:)']);
csvwrite('u460.txt', [yyg' ugp(3,:)']);
csvwrite('u480.txt', [yyg' ugp(4,:)']);
csvwrite('u500.txt', [yyg' ugp(5,:)']);



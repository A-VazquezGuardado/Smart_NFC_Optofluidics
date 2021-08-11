addpath('D:\Dropbox\NWpostdoc\Research\11_(Yixin)Microfluidics\210104_total\tracking_codes') 

load('traj.mat')

load('scatter.mat')

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
    
[xg,yg,ug,vg]=scatter_t2grid2D(scatter_tc, 0, 10, 500, 0, 3, 40);

%contour
ugf1=nanmean(ug(:,:,1:10*10),3);
ugf2=nanmean(ug(:,:,10*10:15*10),3);
ugf3=nanmean(ug(:,:,20*10:25*10),3);

figure
hold on
[c,h]=contourf(xg,yg,ugf2,100);
set(gca,'FontSize',15);
set(h,'LineColor','none');
caxis([0 1800])
colormap(jet)
colorbar
axis equal
axis([280 330 6 36])
box on





scatter_t=traj2scatter_t(traj)
%mean velocity
for i=1:length(scatter_t)
mu(i)=mean(scatter_t(i).u);
end
mu=movmean(mu,500,'omitnan');

t=1:length(mu);
t=t./640
figure
plot(t,mu)


plot_long_trajectories(traj(500:1000),1)
colormap(jet)
colorbar
caxis([0 1200])
view([0 0 1])
%axis equal
grid off
axis equal
axis([0 520 0 52])

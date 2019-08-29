FROM hyperdyne/blender:2.79
COPY ./bmw27_cpu.blend /media
#ENTRYPOINT ["/usr/local/blender/blender","--threads","0","--background","/media/forest.blend","-F","PNG","--render-output","/media/frame_###","-a"]
ENTRYPOINT ["/usr/local/blender/blender","--threads","0","--background","/media/bmw27_cpu.blend","-F","PNG","--render-output","/media/frame_###","--render-frame","3"]
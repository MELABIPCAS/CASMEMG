import cv2
import os
import dlib
import numpy as np

def mkdir(path):
        path = path.strip()
        path = path.rstrip("\\")

        isExists = os.path.exists(path)

        if not isExists:
            os.makedirs(path)
            return True
        else:
            return False

if __name__ == '__main__':

    detector = dlib.get_frontal_face_detector()
    # 获取人脸检测器
    predictor = dlib.shape_predictor("shape_predictor_68_face_landmarks.dat")


    dirbdd = '/data/databases/casme3/labeledData/RGB/firstTry/'
    targetpath = '/data/databases/casme3/labeledData/mecss_crop/img/part1/'


    subs = os.listdir(dirbdd)
    for sub in subs:
        seqs = os.listdir(dirbdd+ sub)
        for seq in seqs:
            if '.' in seq:
                continue
            else:
                print(sub +'/'+ seq)
                imgs = os.listdir(dirbdd+ sub +'/'+ seq+'/color/')
                imgs.sort(key=lambda x: (int(x.split('.')[0])))
                kk = 0
                for img in imgs:
                    if img.endswith('.jpg'):
                        frame = cv2.imread(dirbdd + sub +'/'+ seq+'/color/' +img)
                        gray = cv2.cvtColor(frame, cv2.COLOR_BGRA2RGB)
                        dets = detector(gray, 1)
                        if len(dets) == 0:
                            print("NaN")
                            continue
                        else:
                            print(dets)
                            faceW = dets[0].right() - dets[0].left()
                            faceH = dets[0].bottom() - dets[0].top()
                            x_left = max(dets[0].left() - int(faceW/2), 0)
                            x_right = min(dets[0].right() + int(faceW/2), len(frame[0]))
                            y_low = max(dets[0].top() - int(faceH/2), 0)
                            y_high = min(dets[0].bottom() + int(faceH/4), len(frame))
                            width = x_right - x_left
                            height = y_high - y_low
                            print([x_left, x_right, y_low, y_high])
                            size = (width, height)
                            print(size)
                            break
                        kk = kk + 1


                ii =0
                targetfile = targetpath + sub + '/' + seq + '/color/'
                mkdir(targetfile)
                for face in imgs:
                    if face.endswith('.jpg'):
                        frame = cv2.imread(dirbdd + sub + '/' + seq+'/color/' + face)
                        if frame is None:
                            continue
                        else:
                            img_crop = frame[y_low:y_high, x_left:x_right, :]
                            cv2.imwrite(targetfile + face, img_crop)
                            ii = ii + 1
                           # print(ii)








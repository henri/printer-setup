FasdUAS 1.101.10   ��   ��    k             l     ��������  ��  ��        i      	 
 	 I     �� ��
�� .aevtodocnull  �    alis  o      ���� 0 itemlist itemList��   
 k    b       l     ��������  ��  ��        l     ��  ��    � |----------------------------------------------------------------------------------------------------------------------------     �   � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -      l     ��  ��    � �                                                             Configuration                                                                       --     �  &                                                                                                                           C o n f i g u r a t i o n                                                                                                                                               - -      l     ��  ��    � |----------------------------------------------------------------------------------------------------------------------------     �   � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -      l     ��������  ��  ��       !   l     �� " #��   " a [ this will need to be changed depending upon your where the printer setup folder is located    # � $ $ �   t h i s   w i l l   n e e d   t o   b e   c h a n g e d   d e p e n d i n g   u p o n   y o u r   w h e r e   t h e   p r i n t e r   s e t u p   f o l d e r   i s   l o c a t e d !  % & % l     �� ' (��   ' D > if you move this script out somewhere then set the path below    ( � ) ) |   i f   y o u   m o v e   t h i s   s c r i p t   o u t   s o m e w h e r e   t h e n   s e t   t h e   p a t h   b e l o w &  * + * l     �� , -��   , P J set printerSetup_folder to "/Volumes/tech2/Printing & Fonts/PrinterSetup"    - � . . �   s e t   p r i n t e r S e t u p _ f o l d e r   t o   " / V o l u m e s / t e c h 2 / P r i n t i n g   &   F o n t s / P r i n t e r S e t u p " +  / 0 / l     ��������  ��  ��   0  1 2 1 l     �� 3 4��   3 q k if you leave this script in the 'ExampleFiles/HandyDroplets/PrinterLinkDroplet' then just leave this blank    4 � 5 5 �   i f   y o u   l e a v e   t h i s   s c r i p t   i n   t h e   ' E x a m p l e F i l e s / H a n d y D r o p l e t s / P r i n t e r L i n k D r o p l e t '   t h e n   j u s t   l e a v e   t h i s   b l a n k 2  6 7 6 r      8 9 8 m      : : � ; ;   9 o      ���� *0 printersetup_folder printerSetup_folder 7  < = < l   ��������  ��  ��   =  > ? > l   ��������  ��  ��   ?  @ A @ l   �� B C��   B � }----------------------------------------------------------------------------------------------------------------------------	    C � D D � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 	 A  E F E l   ��������  ��  ��   F  G�� G T   b H H k   	] I I  J K J l  	 	��������  ��  ��   K  L M L l  	 	��������  ��  ��   M  N O N l  	 	�� P Q��   P Q K Get Printer Setup Path if it has not been set in the configuration section    Q � R R �   G e t   P r i n t e r   S e t u p   P a t h   i f   i t   h a s   n o t   b e e n   s e t   i n   t h e   c o n f i g u r a t i o n   s e c t i o n O  S T S Z   	 t U V���� U =  	  W X W o   	 
���� *0 printersetup_folder printerSetup_folder X m   
  Y Y � Z Z   V k    p [ [  \ ] \ Q    \ ^ _ ` ^ k    M a a  b c b r     d e d m     f f � g g � / E x a m p l e F i l e s / H a n d y   D r o p l e t s / P r i n t e r S e t u p W i n d o w s B a t c h F i l e D r o p l e t e o      ���� 0 path_from_root   c  h i h r     j k j l    l���� l I   �� m��
�� .earsffdralis        afdr m  f    ��  ��  ��   k o      ���� 0 mypath myPath i  n o n r    # p q p n    ! r s r 1    !��
�� 
psxp s o    ���� 0 mypath myPath q o      ���� 0 myposixpath myPosixPath o  t u t r   $ / v w v I  $ -�� x��
�� .sysoexecTEXT���     TEXT x b   $ ) y z y b   $ ' { | { m   $ % } } � ~ ~  d i r n a m e   " | o   % &���� 0 myposixpath myPosixPath z m   ' (   � � �  "��   w o      ���� 0 parent_folder   u  � � � l  0 0�� � ���   � N H if the grep below fails then this droplet is in a non standard location    � � � � �   i f   t h e   g r e p   b e l o w   f a i l s   t h e n   t h i s   d r o p l e t   i s   i n   a   n o n   s t a n d a r d   l o c a t i o n �  � � � I  0 =�� ���
�� .sysoexecTEXT���     TEXT � b   0 9 � � � b   0 7 � � � b   0 5 � � � b   0 3 � � � m   0 1 � � � � �  e c h o   " � o   1 2���� 0 parent_folder   � m   3 4 � � � � �  "   |   g r e p   " � o   5 6���� 0 path_from_root   � m   7 8 � � � � �  "��   �  ��� � r   > M � � � I  > K�� ���
�� .sysoexecTEXT���     TEXT � b   > G � � � b   > E � � � b   > C � � � b   > A � � � m   > ? � � � � �  e c h o   " � o   ? @���� 0 parent_folder   � m   A B � � � � � . "   |   a w k   ' B E G I N   {   F S   =   " � o   C D���� 0 path_from_root   � m   E F � � � � � & "   }   ;   {   p r i n t   $ 1   } '��   � o      ���� *0 printersetup_folder printerSetup_folder��   _ R      ������
�� .ascrerr ****      � ****��  ��   ` k   U \ � �  � � � I   U Z�������� 20 .display_error_determining_printer_setup_folder  ��  ��   �  ��� �  S   [ \��   ]  ��� � Z   ] p � ����� � =  ] b � � � o   ] ^���� *0 printersetup_folder printerSetup_folder � m   ^ a � � � � �   � k   e l � �  � � � I   e j�������� 20 .display_error_determining_printer_setup_folder  ��  ��   �  ��� �  S   k l��  ��  ��  ��  ��  ��   T  � � � l  u u��������  ��  ��   �  � � � l  u u��������  ��  ��   �  � � � l  u u�� � ���   �    Windows Batch File Script    � � � � 4   W i n d o w s   B a t c h   F i l e   S c r i p t �  � � � r   u | � � � b   u z � � � o   u v���� *0 printersetup_folder printerSetup_folder � m   v y � � � � � z / E x a m p l e F i l e s / H a n d y   S c r i p t s / s h - o u t p u t - w i n d o w s - b a t c h - c o d e . b a s h � o      ���� 0 output_script   �  � � � l  } }��������  ��  ��   �  � � � l  } }�� � ���   � [ U Check that the output_script is actually availible - bail out if it is not availible    � � � � �   C h e c k   t h a t   t h e   o u t p u t _ s c r i p t   i s   a c t u a l l y   a v a i l i b l e   -   b a i l   o u t   i f   i t   i s   n o t   a v a i l i b l e �  � � � r   } � � � � I  } ��� ���
�� .sysoexecTEXT���     TEXT � b   } � � � � b   } � � � � m   } � � � � � �  i f   [   - f   " � o   � ����� 0 output_script   � m   � � � � � � � j "   ]   ;   t h e n   e c h o   A V A I L I B L E   ;   e l s e   e c h o   U N A V A I L I B L E ;   f i��   � o      ���� 0 output_script_availiblity   �  � � � Z   � � � ����� � =  � � � � � o   � ����� 0 output_script_availiblity   � m   � � � � � � �  U N A V A I L I B L E � k   � � � �  � � � I  � ��� � �
�� .sysodlogaskr        TEXT � b   � � � � � m   � � � � � � � \ E R R O R !   :   U n a b l e   t o   l o c a t e   t h e   o u t p u t   s c r i p t   :   � o   � ����� 0 output_script   � �� � �
�� 
btns � v   � � � �  ��� � m   � � � � � � �  O K��   � �� ���
�� 
dflt � m   � ����� ��   �  ��� �  S   � ���  ��  ��   �  � � � l  � ���������  ��  ��   �  � � � l  � ���������  ��  ��   �  � � � l  � ���������  ��  ��   �  � � � l  � ��� � ���   � 7 1 Check that the out put file is not already there    � �   b   C h e c k   t h a t   t h e   o u t   p u t   f i l e   i s   n o t   a l r e a d y   t h e r e �  l  � ���������  ��  ��    l  � �����   + % Find where we are saving these files    � J   F i n d   w h e r e   w e   a r e   s a v i n g   t h e s e   f i l e s 	 r   � �

 l  � ����� I  � ���~
� .sysonwflfile    ��� null�~   �}
�} 
prmt m   � � �  S a v e   f i l e   a s : �|
�| 
dflc l  � ��{�z e   � � I  � ��y�x
�y .earsffdralis        afdr m   � ��w
�w afdrdesk�x  �{  �z   �v�u
�v 
dfnm m   � � �   p r i n t e r s e t u p . b a t�u  ��  ��   o      �t�t 0 output_file  	  r   � � n   � � 1   � ��s
�s 
psxp o   � ��r�r 0 output_file   o      �q�q 0 
outputpath 
outputPath  !  l  � ��p�o�n�p  �o  �n  ! "#" Q   � �$%&$ I  � ��m'�l
�m .sysoexecTEXT���     TEXT' b   � �()( b   � �*+* m   � �,, �--  r m   - f   "+ o   � ��k�k 0 
outputpath 
outputPath) m   � �.. �//  "�l  % R      �j�i�h
�j .ascrerr ****      � ****�i  �h  & k   � �00 121 I  � ��g3�f
�g .sysodlogaskr        TEXT3 m   � �44 �55 > E R R O R !   :   O v e r w i t e   e x i s t i n g   f i l e�f  2 6�e6  S   � ��e  # 787 l  � ��d�c�b�d  �c  �b  8 9:9 X   �Y;�a<; k  T== >?> l �`�_�^�`  �_  �^  ? @A@ l �]BC�]  B P Jconverts the apple path to posix, so the path is usable within the shell.    C �DD � c o n v e r t s   t h e   a p p l e   p a t h   t o   p o s i x ,   s o   t h e   p a t h   i s   u s a b l e   w i t h i n   t h e   s h e l l .  A EFE r  GHG n  IJI 1  �\
�\ 
psxpJ o  �[�[ 0 nextitem nextItemH o      �Z�Z 0 itempath itemPathF KLK l �Y�X�W�Y  �X  �W  L MNM l �VOP�V  O  display dialog itemPath   P �QQ . d i s p l a y   d i a l o g   i t e m P a t hN RSR l �U�T�S�U  �T  �S  S TUT l �RVW�R  V ) # Write some data to the output file   W �XX F   W r i t e   s o m e   d a t a   t o   t h e   o u t p u t   f i l eU YZY Q  R[\][ k  3^^ _`_ l �Q�P�O�Q  �P  �O  ` aba I 1�Nc�M
�N .sysoexecTEXT���     TEXTc b  -ded b  )fgf b  'hih b  #jkj b  !lml b  non m  pp �qq  "o o  �L�L 0 output_script  m m   rr �ss  "   "k o  !"�K�K 0 itempath itemPathi m  #&tt �uu  "   > >   "g o  '(�J�J 0 
outputpath 
outputPathe m  ),vv �ww  "�M  b xyx l 22�Iz{�I  z _ Ydisplay dialog "\"" & output_script & "\" \"" & itemPath & "\" >> \"" & outputPath & "\""   { �|| � d i s p l a y   d i a l o g   " \ " "   &   o u t p u t _ s c r i p t   &   " \ "   \ " "   &   i t e m P a t h   &   " \ "   > >   \ " "   &   o u t p u t P a t h   &   " \ " "y }�H} l 22�G�F�E�G  �F  �E  �H  \ R      �D�C�B
�D .ascrerr ****      � ****�C  �B  ] I ;R�A~
�A .sysodlogaskr        TEXT~ b  ;@��� m  ;>�� ��� > E R R O R   :   E r r o r   p r o c e s s i n g   P S F   :  � o  >?�@�@ 0 itempath itemPath �?��
�? 
btns� v  CH�� ��>� m  CF�� ���  O K�>  � �=��<
�= 
dflt� m  KL�;�; �<  Z ��� l SS�:�9�8�:  �9  �8  � ��� l SS�7�6�5�7  �6  �5  � ��4� l SS�3���3  � 7 1 end the loop for running though the list passed	   � ��� b   e n d   t h e   l o o p   f o r   r u n n i n g   t h o u g h   t h e   l i s t   p a s s e d 	�4  �a 0 nextitem nextItem< o   � ��2�2 0 itemlist itemList: ��� l ZZ�1�0�/�1  �0  �/  � ��� l ZZ�.�-�,�.  �-  �,  � ��� l ZZ�+���+  � * $ end the loop for escaping on errors   � ��� H   e n d   t h e   l o o p   f o r   e s c a p i n g   o n   e r r o r s� ���  S  Z[� ��*� l \\�)�(�'�)  �(  �'  �*  ��    ��� l     �&�%�$�&  �%  �$  � ��� i    ��� I     �#�"�!
�# .aevtoappnull  �   � ****�"  �!  � O     ��� k    �� ��� I   	� ��
�  .miscactvnull��� ��� null�  �  � ��� I  
 ���
� .sysodlogaskr        TEXT� m   
 �� ��� | P l e a s e   D r a g   P S F   F i l e s   o n t o   t h e   m e   i n   o r d e r   t o   c r e a t e   p r i n t e r s .�  �  � m     ���                                                                                  MACS  alis    l  
SwiftDrive                 �rpH+   	|�
Finder.app                                                      	�eƘ��        ����  	                CoreServices    ���      ƘK�     	|� 	|~   _  1SwiftDrive:System:Library:CoreServices:Finder.app    
 F i n d e r . a p p   
 S w i f t D r i v e  &System/Library/CoreServices/Finder.app  / ��  � ��� l     ����  �  �  � ��� l     ����  �  �  � ��� l     ����  �  �  � ��� i    ��� I      ���� 20 .display_error_determining_printer_setup_folder  �  �  � k     �� ��� l     ����  �  �  � ��� I    �
��
�
 .sysodlogaskr        TEXT� m     �� ���D E r r o r   D e t e r m i n i n g   P r i n t e r   S e t u p   F o l d e r .   
 
 Y o u   m a y   n e e d   t o   c o n f i g u r e   t h i s   s c r i p t ,   a s   i t   m a y   h a v e   b e e n   m o v e d   f r o m   i t s   o r i g i n a l   l o c a t i o n   i n   t h e   ' E x a m p l e F i l e s '   f o l d e r� �	��
�	 
btns� v    �� ��� m    �� ���  O K�  � ���
� 
dflt� m    �� �  �  � ��� l     ����  �  �  �       � �����   � ������
�� .aevtodocnull  �    alis
�� .aevtoappnull  �   � ****�� 20 .display_error_determining_printer_setup_folder  � �� 
��������
�� .aevtodocnull  �    alis�� 0 itemlist itemList��  � �������������������������� 0 itemlist itemList�� *0 printersetup_folder printerSetup_folder�� 0 path_from_root  �� 0 mypath myPath�� 0 myposixpath myPosixPath�� 0 parent_folder  �� 0 output_script  �� 0 output_script_availiblity  �� 0 output_file  �� 0 
outputpath 
outputPath�� 0 nextitem nextItem�� 0 itempath itemPath� 0 : Y f���� } �� � � � � � ������� � � � � � ��� �������������������,.4������prtv��
�� .earsffdralis        afdr
�� 
psxp
�� .sysoexecTEXT���     TEXT��  ��  �� 20 .display_error_determining_printer_setup_folder  
�� 
btns
�� 
dflt�� 
�� .sysodlogaskr        TEXT
�� 
prmt
�� 
dflc
�� afdrdesk
�� 
dfnm�� 
�� .sysonwflfile    ��� null
�� 
kocl
�� 
cobj
�� .corecnte****       ****��c�E�O]hZ��  f @�E�O)j E�O��,E�O�%�%j E�O�%�%�%�%j O�%�%�%�%j E�W X  *j+ OO�a   *j+ OY hY hO�a %E�Oa �%a %j E�O�a   a �%a a ka ka  OY hO*a a a a j a  a !a " #E�O��,E�O a $�%a %%j W X  a &j OO ]�[a 'a (l )kh 
��,E�O  a *�%a +%�%a ,%�%a -%j OPW X  a .�%a a /ka ka  OP[OY��OOP[OY��� �����������
�� .aevtoappnull  �   � ****��  ��  �  � ������
�� .miscactvnull��� ��� null
�� .sysodlogaskr        TEXT�� � *j O�j U� ������������� 20 .display_error_determining_printer_setup_folder  ��  ��  �  � ����������
�� 
btns
�� 
dflt�� 
�� .sysodlogaskr        TEXT�� ���k�k�  ascr  ��ޭ
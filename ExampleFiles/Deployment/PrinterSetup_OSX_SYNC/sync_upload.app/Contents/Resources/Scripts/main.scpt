FasdUAS 1.101.10   ��   ��    k             l     ��  ��      Configuration     � 	 	    C o n f i g u r a t i o n   
  
 l     ����  r         m        �    . / s c r i p t s  o      ���� ~0 =printersetup_deployment_shell_scripts_direcotry_realitve_path =printerSetup_deployment_shell_scripts_direcotry_realitve_path��  ��        l    ����  r        m       �    u p l o a d . b a s h  o      ���� X0 *printersetup_deployment_uplaod_script_name *printerSetup_deployment_uplaod_script_name��  ��        l     ��������  ��  ��        l     ��������  ��  ��        l     ��  ��     Some other varibles     �     & S o m e   o t h e r   v a r i b l e s   ! " ! l    #���� # r     $ % $ m    	��
�� boovfals % o      ���� 0 usercanceled userCanceled��  ��   "  & ' & l    (���� ( r     ) * ) m     + + � , ,   * o      ���� \0 ,printersetup_deployment_uplaod_absolute_path ,printerSetup_deployment_uplaod_absolute_path��  ��   '  - . - l     ��������  ��  ��   .  / 0 / l   � 1���� 1 T    � 2 2 k    � 3 3  4 5 4 l   ��������  ��  ��   5  6 7 6 l   ��������  ��  ��   7  8 9 8 l   �� : ;��   :   Resolve some paths    ; � < < &   R e s o l v e   s o m e   p a t h s 9  = > = Q    V ? @ A ? k    G B B  C D C r     E F E l    G���� G I   �� H��
�� .earsffdralis        afdr H  f    ��  ��  ��   F o      ���� 0 mypath myPath D  I J I r     % K L K n     # M N M 1   ! #��
�� 
psxp N o     !���� 0 mypath myPath L o      ���� 0 myposixpath myPosixPath J  O P O r   & 1 Q R Q I  & /�� S��
�� .sysoexecTEXT���     TEXT S b   & + T U T b   & ) V W V m   & ' X X � Y Y  d i r n a m e   " W o   ' (���� 0 myposixpath myPosixPath U m   ) * Z Z � [ [  "��   R o      ���� 0 parent_folder   P  \ ] \ r   2 ; ^ _ ^ b   2 7 ` a ` b   2 5 b c b o   2 3���� 0 parent_folder   c m   3 4 d d � e e  / a o   5 6���� ~0 =printersetup_deployment_shell_scripts_direcotry_realitve_path =printerSetup_deployment_shell_scripts_direcotry_realitve_path _ o      ���� ~0 =printersetup_deployment_shell_scripts_direcotry_absolute_path =printerSetup_deployment_shell_scripts_direcotry_absolute_path ]  f�� f r   < G g h g b   < E i j i b   < C k l k o   < ?���� ~0 =printersetup_deployment_shell_scripts_direcotry_absolute_path =printerSetup_deployment_shell_scripts_direcotry_absolute_path l m   ? B m m � n n  / j o   C D���� X0 *printersetup_deployment_uplaod_script_name *printerSetup_deployment_uplaod_script_name h o      ���� \0 ,printersetup_deployment_uplaod_absolute_path ,printerSetup_deployment_uplaod_absolute_path��   @ R      ������
�� .ascrerr ****      � ****��  ��   A k   O V o o  p q p I   O T�������� '0 #display_error_determining_directory  ��  ��   q  r�� r  S   U V��   >  s t s l  W W��������  ��  ��   t  u v u l  W W��������  ��  ��   v  w x w l  W W��������  ��  ��   x  y z y l  W W�� { |��   { ' ! Check that they want to go ahead    | � } } B   C h e c k   t h a t   t h e y   w a n t   t o   g o   a h e a d z  ~  ~ Q   W � � � � � k   Z � � �  � � � r   Z � � � � I  Z ��� � �
�� .sysodlogaskr        TEXT � m   Z ] � � � � � � U p d a t e   t h e   P r i n t e r S e t u p   c o n f i g u r a t o n   o n   t h e   s e r v e r ?   
 
   S E R V E R   D A T A   C O U L D   B E   L O S T ! � �� � �
�� 
btns � v   ` h � �  � � � m   ` c � � � � � & U p l o a d   P r i n t e r S e t u p �  ��� � m   c f � � � � �  C a n c e l��   � �� � �
�� 
dflt � m   k l����  � �� � �
�� 
disp � m   o r��
�� stic     � �� � �
�� 
cbtn � m   u x � � � � �  C a n c e l � �� ���
�� 
givu � m   { |����  ��   � o      ���� 0 dialogresult dialogResult �  ��� � l  � ���������  ��  ��  ��   � R      ���� �
�� .ascrerr ****      � ****��   � �� ���
�� 
errn � d       � � m      ���� ���   � r   � � � � � m   � ���
�� boovtrue � o      ���� 0 usercanceled userCanceled   � � � l  � ���������  ��  ��   �  � � � Z   � � � � ��� � o   � ����� 0 usercanceled userCanceled � k   � � � �  � � �  S   � � �  ��� � l  � ���������  ��  ��  ��   �  � � � =  � � � � � n   � � � � � 1   � ���
�� 
bhit � o   � ����� 0 dialogresult dialogResult � m   � � � � � � � & U p l o a d   P r i n t e r S e t u p �  � � � k   � � � �  � � � l  � ���������  ��  ��   �  � � � l  � ��� � ���   � 0 * This is where we actually run the update.    � � � � T   T h i s   i s   w h e r e   w e   a c t u a l l y   r u n   t h e   u p d a t e . �  � � � l  � ���������  ��  ��   �  � � � Q   � � � ��� � O   � � � � � k   � � � �  � � � I  � �������
�� .miscactvnull��� ��� null��  ��   �  ��� � I  � ��� ���
�� .coredoscnull��� ��� ctxt � b   � � � � � b   � � � � � m   � � � � � � �  " � o   � ����� \0 ,printersetup_deployment_uplaod_absolute_path ,printerSetup_deployment_uplaod_absolute_path � m   � � � � � � � T "   ;   e c h o   " E x i t i n g   S h e l l . . . " ;   s l e e p   2 ;   e x i t��  ��   � m   � � � ��                                                                                      @  alis    ^  Local-HD                   ê\�H+   2�Terminal.app                                                    ���8        ����  	                	Utilities     é��      �Vx     2�     ,Local-HD:Applications:Utilities:Terminal.app    T e r m i n a l . a p p    L o c a l - H D  #Applications/Utilities/Terminal.app   / ��   � R      ������
�� .ascrerr ****      � ****��  ��  ��   �  � � � l  � ���������  ��  ��   �  � � �  S   � � �  � � � l  � ���������  ��  ��   �  �� � l  � ��~�}�|�~  �}  �|  �   �  � � � n   � � � � � 1   � ��{
�{ 
gavu � o   � ��z�z 0 dialogresult dialogResult �  ��y � k   � � � �  � � � l  � ��x � ��x   � B < statements to execute if dialog timed out without an answer    � � � � x   s t a t e m e n t s   t o   e x e c u t e   i f   d i a l o g   t i m e d   o u t   w i t h o u t   a n   a n s w e r �  � � � I  � ��w ��v
�w .sysodlogaskr        TEXT � m   � � � � � � � X T i m e d   o u t   w a i t i n g   f o r   D o w n l o a d   v e r i f i c a t i o n .�v   �  ��u �  S   � ��u  �y  ��   �  � � � l  � ��t�s�r�t  �s  �r   �  � � � l  � ��q�p�o�q  �p  �o   �  � � � l  � ��n�m�l�n  �m  �l   �  ��k �  S   � ��k  ��  ��   0  � � � l     �j�i�h�j  �i  �h   �  � � � l     �g�f�e�g  �f  �e   �  � � � l     �d�c�b�d  �c  �b   �  � � � l     �a�`�_�a  �`  �_   �  �  � i      I      �^�]�\�^ '0 #display_error_determining_directory  �]  �\   k       l     �[�Z�Y�[  �Z  �Y    I    �X	
�X .sysodlogaskr        TEXT m     

 � V E r r o r   D e t e r m i n i n g   C u r r e n t   D i r e c t o r y   F o l d e r .	 �W
�W 
btns v     �V m     �  O K�V   �U�T
�U 
dflt m    �S�S �T   �R l   �Q�P�O�Q  �P  �O  �R    �N l     �M�L�K�M  �L  �K  �N       �J  �I�H�G�F�E�D�J   �C�B�A�@�?�>�=�<�;�:�9�8�7�6�5�4�C '0 #display_error_determining_directory  
�B .aevtoappnull  �   � ****�A ~0 =printersetup_deployment_shell_scripts_direcotry_realitve_path =printerSetup_deployment_shell_scripts_direcotry_realitve_path�@ X0 *printersetup_deployment_uplaod_script_name *printerSetup_deployment_uplaod_script_name�? 0 usercanceled userCanceled�> \0 ,printersetup_deployment_uplaod_absolute_path ,printerSetup_deployment_uplaod_absolute_path�= 0 mypath myPath�< 0 myposixpath myPosixPath�; 0 parent_folder  �: ~0 =printersetup_deployment_shell_scripts_direcotry_absolute_path =printerSetup_deployment_shell_scripts_direcotry_absolute_path�9 0 dialogresult dialogResult�8  �7  �6  �5  �4   �3�2�1�0�3 '0 #display_error_determining_directory  �2  �1     
�/�.�-�,
�/ 
btns
�. 
dflt�- 
�, .sysodlogaskr        TEXT�0 ���k�k� OP �+ �*�)!"�(
�+ .aevtoappnull  �   � ****  k     �##  
$$  %%  !&&  &''  /�'�'  �*  �)  !  " , �& �%�$ +�#�"�!� � X Z�� d� m��� �� � ����� �����(� � �� � ��� ��& ~0 =printersetup_deployment_shell_scripts_direcotry_realitve_path =printerSetup_deployment_shell_scripts_direcotry_realitve_path�% X0 *printersetup_deployment_uplaod_script_name *printerSetup_deployment_uplaod_script_name�$ 0 usercanceled userCanceled�# \0 ,printersetup_deployment_uplaod_absolute_path ,printerSetup_deployment_uplaod_absolute_path
�" .earsffdralis        afdr�! 0 mypath myPath
�  
psxp� 0 myposixpath myPosixPath
� .sysoexecTEXT���     TEXT� 0 parent_folder  � ~0 =printersetup_deployment_shell_scripts_direcotry_absolute_path =printerSetup_deployment_shell_scripts_direcotry_absolute_path�  �  � '0 #display_error_determining_directory  
� 
btns
� 
dflt
� 
disp
� stic    
� 
cbtn
� 
givu� 

� .sysodlogaskr        TEXT� 0 dialogresult dialogResult( ��
�	
� 
errn�
���	  
� 
bhit
� .miscactvnull��� ��� null
� .coredoscnull��� ��� ctxt
� 
gavu�( ��E�O�E�OfE�O�E�O �hZ 4)j E�O��,E�O��%�%j E�O��%�%E` O_ a %�%E�W X  *j+ OO 3a a a a la la a a a a ja   E` !OPW 
X  "eE�O� OPY U_ !a #,a $  / a % *j &Oa '�%a (%j )UW X  hOOPY _ !a *,E a +j  OY hO[OY�
�I boovfals �)) � / U s e r s / s m c / D e s k t o p / P r i n t e r S e t u p _ v 0 0 2 7 / E x a m p l e F i l e s / D e p l o y m e n t / P r i n t e r S e t u p _ O S X _ S Y N C / . / s c r i p t s / u p l o a d . b a s halis      Local-HD                   ê\�H+   00sync_upload.app                                                 0c�GLr        ����  	                PrinterSetup_OSX_SYNC     é��      �F��     00 0h 0f 0b 
 W 
 R 
 N  kLocal-HD:Users:smc:Desktop:PrinterSetup_v0027:ExampleFiles:Deployment:PrinterSetup_OSX_SYNC:sync_upload.app      s y n c _ u p l o a d . a p p    L o c a l - H D  bUsers/smc/Desktop/PrinterSetup_v0027/ExampleFiles/Deployment/PrinterSetup_OSX_SYNC/sync_upload.app  /    
��   �** � / U s e r s / s m c / D e s k t o p / P r i n t e r S e t u p _ v 0 0 2 7 / E x a m p l e F i l e s / D e p l o y m e n t / P r i n t e r S e t u p _ O S X _ S Y N C / s y n c _ u p l o a d . a p p / �++ � / U s e r s / s m c / D e s k t o p / P r i n t e r S e t u p _ v 0 0 2 7 / E x a m p l e F i l e s / D e p l o y m e n t / P r i n t e r S e t u p _ O S X _ S Y N C �,, � / U s e r s / s m c / D e s k t o p / P r i n t e r S e t u p _ v 0 0 2 7 / E x a m p l e F i l e s / D e p l o y m e n t / P r i n t e r S e t u p _ O S X _ S Y N C / . / s c r i p t s �-�
� 
bhit- �.. & U p l o a d   P r i n t e r S e t u p�  �H  �G  �F  �E  �D  ascr  ��ޭ
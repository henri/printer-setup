FasdUAS 1.101.10   ��   ��    k             l     ��������  ��  ��        l   � 	���� 	 T    � 
 
 k   �       l   ��������  ��  ��        r        m       �      o      ���� *0 printersetup_folder printerSetup_folder      r   	     m   	 
   �      o      ���� 0 partner_script_absolute        r        m       �   2 d o m a i n _ c o n f i g u r a t i o n . b a s h  o      ���� 0 partner_script_name       !   l   ��������  ��  ��   !  " # " l   �� $ %��   $ | v Get Printer Setup Path and also setup the partner_script_absolute if it has not been set in the configuration section    % � & & �   G e t   P r i n t e r   S e t u p   P a t h   a n d   a l s o   s e t u p   t h e   p a r t n e r _ s c r i p t _ a b s o l u t e   i f   i t   h a s   n o t   b e e n   s e t   i n   t h e   c o n f i g u r a t i o n   s e c t i o n #  ' ( ' Z    � ) *���� ) =    + , + o    ���� *0 printersetup_folder printerSetup_folder , m     - - � . .   * k    � / /  0 1 0 Q    � 2 3 4 2 k    y 5 5  6 7 6 r     8 9 8 m     : : � ; ; � / E x a m p l e F i l e s / D e p l o y m e n t / P r i n t e r S e t u p _ O S X _ D Y N A M I C / P r i n t e r S e t u p _ D y n a m i c _ C o n f i g u r a t i o n _ I n s t a l l e r - t e m p l a t e / s c r i p t s 9 o      ���� 0 path_from_root   7  < = < r    ! > ? > m     @ @ � A A b / E x a m p l e F i l e s / D e p l o y m e n t / P r i n t e r S e t u p _ O S X _ D Y N A M I C ? o      ���� 0 path_from_root_minimal   =  B C B r   " ) D E D l  " ' F���� F I  " '�� G��
�� .earsffdralis        afdr G  f   " #��  ��  ��   E o      ���� 0 mypath myPath C  H I H r   * / J K J n   * - L M L 1   + -��
�� 
psxp M o   * +���� 0 mypath myPath K o      ���� 0 myposixpath myPosixPath I  N O N r   0 ? P Q P I  0 ;�� R��
�� .sysoexecTEXT���     TEXT R b   0 7 S T S b   0 3 U V U m   0 1 W W � X X  d i r n a m e   " V o   1 2���� 0 myposixpath myPosixPath T m   3 6 Y Y � Z Z  "��   Q o      ���� 0 parent_folder   O  [ \ [ l  @ @�� ] ^��   ] N H if the grep below fails then this droplet is in a non standard location    ^ � _ _ �   i f   t h e   g r e p   b e l o w   f a i l s   t h e n   t h i s   d r o p l e t   i s   i n   a   n o n   s t a n d a r d   l o c a t i o n \  ` a ` I  @ U�� b��
�� .sysoexecTEXT���     TEXT b b   @ Q c d c b   @ M e f e b   @ K g h g b   @ G i j i m   @ C k k � l l  e c h o   " j o   C F���� 0 parent_folder   h m   G J m m � n n  "   |   g r e p   " f o   K L���� 0 path_from_root   d m   M P o o � p p  "��   a  q r q r   V m s t s I  V k�� u��
�� .sysoexecTEXT���     TEXT u b   V g v w v b   V c x y x b   V a z { z b   V ] | } | m   V Y ~ ~ �    e c h o   " } o   Y \���� 0 parent_folder   { m   ] ` � � � � � 0 "   |     a w k   ' B E G I N   {   F S   =   " y o   a b���� 0 path_from_root_minimal   w m   c f � � � � � & "   }   ;   {   p r i n t   $ 1   } '��   t o      ���� *0 printersetup_folder printerSetup_folder r  ��� � r   n y � � � b   n w � � � b   n u � � � b   n q � � � o   n o���� *0 printersetup_folder printerSetup_folder � o   o p���� 0 path_from_root   � m   q t � � � � �  / � o   u v���� 0 partner_script_name   � o      ���� 0 partner_script_absolute  ��   3 R      ������
�� .ascrerr ****      � ****��  ��   4 k   � � � �  � � � I   � ��������� 20 .display_error_determining_printer_setup_folder  ��  ��   �  ��� �  S   � ���   1  ��� � Z   � � � ����� � =  � � � � � o   � ����� *0 printersetup_folder printerSetup_folder � m   � � � � � � �   � k   � � � �  � � � I   � ��������� 20 .display_error_determining_printer_setup_folder  ��  ��   �  ��� �  S   � ���  ��  ��  ��  ��  ��   (  � � � l  � ���������  ��  ��   �  � � � l  � ��� � ���   � * $check that the partner script exists    � � � � H c h e c k   t h a t   t h e   p a r t n e r   s c r i p t   e x i s t s �  � � � r   � � � � � I  � ��� ���
�� .sysoexecTEXT���     TEXT � b   � � � � � b   � � � � � m   � � � � � � �  i f   [   - x   � o   � ����� 0 partner_script_absolute   � m   � � � � � � � L   ]   ;   t h e n   e c h o   Y E S   ;   e l s e   e c h o   N O   ;   f i��   � o      ���� 0 partner_script_exits   �  � � � Z   � � � ����� � =  � � � � � o   � ����� 0 partner_script_exits   � m   � � � � � � �  N O � k   � � � �  � � � I  � ��� � �
�� .sysodlogaskr        TEXT � m   � � � � � � �Z E R R O R !   :   T h e   p a r t n e r   s c r i p t   w a s   u n a b l e   t o   b e   l o c a t e d   o r   i s   n o t   e x e c u t a b l e .   P l e a s e   c o n f i r m   t h e   p a r t n e r   s c r i p t   i s   a v a i l i b l e   a n d   h a s   t h e   c o r r e c t   p e r m i s s i o n s   a n d   t h e n   t r y   a g a i n . � �� � �
�� 
btns � J   � � � �  ��� � m   � � � � � � �  O K��   � �� ���
�� 
dflt � m   � ����� ��   �  ��� �  S   � ���  ��  ��   �  � � � l  � ���������  ��  ��   �  � � � l  � ���������  ��  ��   �  � � � r   � � � � � m   � ���
�� boovfals � o      ���� 0 usercanceled userCanceled �  � � � l  � ���������  ��  ��   �  � � � Q   �7 � � � � k   �( � �  � � � l  � ���������  ��  ��   �  � � � r   � � � � � m   � � � � � � � � S p e c i f y   t h e   d o m a i n   n a m e   f o r   w h i c h   y o u   w o u l d   l i k e   t o   g e n e r a t e   a   d o m a i n   s p e c i f i c   i n s t a l l e r . � o      ���� 0 request_text   �  � � � l  � ���������  ��  ��   �  � � � r   � � � � � m   � � � � � � �  y o u r . d o m a i n . c o m � o      ���� 0 default_answer_text   �  � � � l  � ���������  ��  ��   �  � � � r   �& � � � I  �"�� � �
�� .sysodlogaskr        TEXT � o   � ����� 0 request_text   � �� � �
�� 
dtxt � o   � ����� 0 default_answer_text   � �� � �
�� 
btns � J   � � �  � � � m   � � � � � �  C a n c e l �  ��� � m   � � � � � T G e n e r a t e   D o m a i n   S p e c i f i c   D y n a m i c   I n s t a l l e r��   � �� � �
�� 
dflt � m  	 � � �   T G e n e r a t e   D o m a i n   S p e c i f i c   D y n a m i c   I n s t a l l e r � ��
�� 
cbtn m   �  C a n c e l ��
�� 
appr m   � R G e n e r a t e   D o m i n   S p e c i f i c   D y n a m i c   I n s t a l l e r ��	��
�� 
givu	 m  ����  ��   � o      ���� 0 dialogresult dialogResult � 
��
 l ''��������  ��  ��  ��   � R      ����
�� .ascrerr ****      � ****��   ����
�� 
errn d       m      ���� ���   � k  07  r  05 m  01��
�� boovtrue o      ���� 0 usercanceled userCanceled �� l 66��~�}�  �~  �}  ��   �  l 88�|�{�z�|  �{  �z    l 88�y�x�w�y  �x  �w    Z  8a�v o  8;�u�u 0 usercanceled userCanceled k  >A   S  >?  �t  l @@�s�r�q�s  �r  �q  �t   !"! = DO#$# n  DK%&% 1  GK�p
�p 
bhit& o  DG�o�o 0 dialogresult dialogResult$ m  KN'' �(( T G e n e r a t e   D o m a i n   S p e c i f i c   D y n a m i c   I n s t a l l e r" )�n) r  R]*+* n  RY,-, 1  UY�m
�m 
ttxt- o  RU�l�l 0 dialogresult dialogResult+ o      �k�k 0 domain_name  �n  �v   ./. l bb�j�i�h�j  �i  �h  / 010 l bb�g23�g  2 K E Run the script and set up this new dynamic domain specific installer   3 �44 �   R u n   t h e   s c r i p t   a n d   s e t   u p   t h i s   n e w   d y n a m i c   d o m a i n   s p e c i f i c   i n s t a l l e r1 565 I bw�f7�e
�f .sysoexecTEXT���     TEXT7 b  bs898 b  bo:;: b  bk<=< b  bg>?> m  be@@ �AA  "? o  ef�d�d 0 partner_script_absolute  = m  gjBB �CC  "   "; o  kn�c�c 0 domain_name  9 m  orDD �EE  "�e  6 FGF l xx�b�a�`�b  �a  �`  G HIH l xx�_JK�_  J 6 0 edit the appropriate files - if we get the okay   K �LL `   e d i t   t h e   a p p r o p r i a t e   f i l e s   -   i f   w e   g e t   t h e   o k a yI MNM I x}�^�]�\
�^ .miscactvnull��� ��� null�]  �\  N OPO r  ~�QRQ I ~��[ST
�[ .sysodlogaskr        TEXTS m  ~�UU �VV j I t   i s   r e c c o m e n d e d   t h a t   y o u   e d i t   t h e   " d y n a m i c _ s c r i p t " .T �ZWX
�Z 
btnsW J  ��YY Z[Z m  ��\\ �]] 8 I   w i l l   e d i t   t h e   s c r i p t   l a t e r[ ^�Y^ m  ��__ �`` : O K   I   w i l l   e d i t   t h e   s c r i p t   n o w�Y  X �Xa�W
�X 
dflta m  ���V�V �W  R o      �U�U 0 dialogresult dialogResultP bcb Z  ��de�T�Sd = ��fgf n  ��hih 1  ���R
�R 
bhiti o  ���Q�Q 0 dialogresult dialogResultg m  ��jj �kk : O K   I   w i l l   e d i t   t h e   s c r i p t   n o we k  ��ll mnm r  ��opo b  ��qrq b  ��sts b  ��uvu b  ��wxw b  ��yzy o  ���P�P *0 printersetup_folder printerSetup_folderz m  ��{{ �|| � / E x a m p l e F i l e s / D e p l o y m e n t / P r i n t e r S e t u p _ O S X _ D Y N A M I C / P r i n t e r S e t u p _ D y n a m i c _ C o n f i g u r a t i o n _ I n s t a l l e r -x o  ���O�O 0 domain_name  v m  ��}} �~~ v / r o o t / e t c / p r i n t e r s e t u p / c o n f i g u r a t i o n s / p r i n t e r s e t u p - d y n a m i c .t o  ���N�N 0 domain_name  r m  �� ���  / d y n a m i c _ s c r i p tp o      �M�M 0 dynamic_script_absolute  n ��L� I ���K��J
�K .sysoexecTEXT���     TEXT� b  ����� b  ����� m  ���� ��� $ o p e n   - a   T e x t E d i t   "� o  ���I�I 0 dynamic_script_absolute  � m  ���� ���  "�J  �L  �T  �S  c ��� l ���H�G�F�H  �G  �F  � ��� l ���E�D�C�E  �D  �C  � ��� l ���B���B  �  	 Finsihed   � ���    F i n s i h e d� ���  S  ��� ��� l ���A�@�?�A  �@  �?  � ��� l ���>�=�<�>  �=  �<  � ��;� l ���:�9�8�:  �9  �8  �;  ��  ��    ��� l     �7�6�5�7  �6  �5  � ��� l     �4�3�2�4  �3  �2  � ��� l     �1�0�/�1  �0  �/  � ��� l     �.�-�,�.  �-  �,  � ��� i     ��� I      �+�*�)�+ 20 .display_error_determining_printer_setup_folder  �*  �)  � k     �� ��� l     �(�'�&�(  �'  �&  � ��%� I    �$��
�$ .sysodlogaskr        TEXT� m     �� ���B E r r o r   D e t e r m i n i n g   P r i n t e r   S e t u p   F o l d e r . 
 
 Y o u   m a y   n e e d   t o   c o n f i g u r e   t h i s   s c r i p t ,   a s   i t   m a y   h a v e   b e e n   m o v e d   f r o m   i t s   o r i g i n a l   l o c a t i o n   i n   t h e   ' E x a m p l e F i l e s '   f o l d e r� �#��
�# 
btns� J    �� ��"� m    �� ���  O K�"  � �!�� 
�! 
dflt� m    �� �   �%  � ��� l     ����  �  �  �       ������  : @����� � ����  � ���������������
�	� 20 .display_error_determining_printer_setup_folder  
� .aevtoappnull  �   � ****� *0 printersetup_folder printerSetup_folder� 0 partner_script_absolute  � 0 partner_script_name  � 0 path_from_root  � 0 path_from_root_minimal  � 0 mypath myPath� 0 myposixpath myPosixPath� 0 parent_folder  � 0 partner_script_exits  � 0 usercanceled userCanceled� 0 request_text  � 0 default_answer_text  �
 0 dialogresult dialogResult�	 0 domain_name  � �������� 20 .display_error_determining_printer_setup_folder  �  �  �  � ������
� 
btns
� 
dflt� 
� .sysodlogaskr        TEXT� ���kv�k� � � ���������
�  .aevtoappnull  �   � ****� k    ���  ����  ��  ��  �  � K �� �� �� - :�� @���������� W Y���� k m o ~ � � ������� � � ��� � ��� ��������� ��� ����� � � ��������������'����@BD��U\_j{}������ *0 printersetup_folder printerSetup_folder�� 0 partner_script_absolute  �� 0 partner_script_name  �� 0 path_from_root  �� 0 path_from_root_minimal  
�� .earsffdralis        afdr�� 0 mypath myPath
�� 
psxp�� 0 myposixpath myPosixPath
�� .sysoexecTEXT���     TEXT�� 0 parent_folder  ��  ��  �� 20 .display_error_determining_printer_setup_folder  �� 0 partner_script_exits  
�� 
btns
�� 
dflt�� 
�� .sysodlogaskr        TEXT�� 0 usercanceled userCanceled�� 0 request_text  �� 0 default_answer_text  
�� 
dtxt
�� 
cbtn
�� 
appr
�� 
givu�� �� 0 dialogresult dialogResult� ������
�� 
errn������  
�� 
bhit
�� 
ttxt�� 0 domain_name  
�� .miscactvnull��� ��� null�� 0 dynamic_script_absolute  ����hZ�E�O�E�O�E�O��  � d�E�O�E�O)j E�O��,E�O��%a %j E` Oa _ %a %�%a %j Oa _ %a %�%a %j E�O��%a %�%E�W X  *j+ OO�a   *j+ OY hY hOa �%a %j E`  O_  a !  a "a #a $kva %ka & 'OY hOfE` (O Ka )E` *Oa +E` ,O_ *a -_ ,a #a .a /lva %a 0a 1a 2a 3a 4a 5ja 6 'E` 7OPW X  8eE` (OPO_ ( OPY _ 7a 9,a :  _ 7a ;,E` <Y hOa =�%a >%_ <%a ?%j O*j @Oa Aa #a Ba Clva %la & 'E` 7O_ 7a 9,a D  .�a E%_ <%a F%_ <%a G%E` HOa I_ H%a J%j Y hOOP[OY�'� ��� J / S t o r a g e / D o w n l a o d s / P r i n t e r S e t u p _ v 0 0 3 6� ���\ / S t o r a g e / D o w n l a o d s / P r i n t e r S e t u p _ v 0 0 3 6 / E x a m p l e F i l e s / D e p l o y m e n t / P r i n t e r S e t u p _ O S X _ D Y N A M I C / P r i n t e r S e t u p _ D y n a m i c _ C o n f i g u r a t i o n _ I n s t a l l e r - t e m p l a t e / s c r i p t s / d o m a i n _ c o n f i g u r a t i o n . b a s h��alis    �  SwiftMacDrive              �l�H+   !��domain_configuration.app                                        "(��H6�        ����  	                scripts     �k�R      �G�l      !�� !�p !�l !�h !�d !�[ 
z4 
z2  �SwiftMacDrive:Storage:Downlaods:PrinterSetup_v0036:ExampleFiles:Deployment:PrinterSetup_OSX_DYNAMIC:PrinterSetup_Dynamic_Con#21ED70:scripts:domain_configuration.app  2  d o m a i n _ c o n f i g u r a t i o n . a p p    S w i f t M a c D r i v e  �Storage/Downlaods/PrinterSetup_v0036/ExampleFiles/Deployment/PrinterSetup_OSX_DYNAMIC/PrinterSetup_Dynamic_Configuration_Installer-template/scripts/domain_configuration.app  / ��  � ���\ / S t o r a g e / D o w n l a o d s / P r i n t e r S e t u p _ v 0 0 3 6 / E x a m p l e F i l e s / D e p l o y m e n t / P r i n t e r S e t u p _ O S X _ D Y N A M I C / P r i n t e r S e t u p _ D y n a m i c _ C o n f i g u r a t i o n _ I n s t a l l e r - t e m p l a t e / s c r i p t s / d o m a i n _ c o n f i g u r a t i o n . a p p /� ���( / S t o r a g e / D o w n l a o d s / P r i n t e r S e t u p _ v 0 0 3 6 / E x a m p l e F i l e s / D e p l o y m e n t / P r i n t e r S e t u p _ O S X _ D Y N A M I C / P r i n t e r S e t u p _ D y n a m i c _ C o n f i g u r a t i o n _ I n s t a l l e r - t e m p l a t e / s c r i p t s� ���  Y E S
� boovfals� ����
�� 
ttxt� ���  t h e . d o m a i n . c o m� �����
�� 
bhit� ��� T G e n e r a t e   D o m a i n   S p e c i f i c   D y n a m i c   I n s t a l l e r��  ascr  ��ޭ
SELECT ������.����_��������, ������.*
FROM     ������ INNER JOIN
                  ������ ON ������.������������_������ = ������.������������
WHERE  (������.����_�������� > CONVERT(DATETIME, '2020-01-21 00:00:00', 102))

SELECT ������.*
FROM     ������
WHERE  (���� BETWEEN 64 AND 319)

SELECT ��������, ������������_������
FROM     ������
WHERE ([������������_������] = N'������� �����')

SELECT �����_������, ������������_������ AS �����, ����_�������, ����������, ��������, ����_��������
FROM     ������
WHERE  (�������� = N'�� "���� � ������"')
ORDER BY ����_��������
USE master;
GO

IF DB_ID(N'QuanLySinhVien') IS NOT NULL
BEGIN
    ALTER DATABASE QuanLySinhVien SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE QuanLySinhVien;
END
GO

CREATE DATABASE QuanLySinhVien;
GO
USE QuanLySinhVien;
GO

CREATE TABLE TaiKhoan (
    MaTK         INT IDENTITY(1,1) PRIMARY KEY,
    TenDangNhap  VARCHAR(50)  NOT NULL UNIQUE,
    MatKhauHash  VARCHAR(64)  NOT NULL,         
    QuyenHan     NVARCHAR(20) NOT NULL DEFAULT N'NhanVien'
        CHECK (QuyenHan IN (N'Admin', N'NhanVien'))
);

CREATE TABLE Khoa (
    MaKhoa  VARCHAR(10)   PRIMARY KEY,
    TenKhoa NVARCHAR(100) NOT NULL
);

CREATE TABLE Lop (
    MaLop   VARCHAR(20)   PRIMARY KEY,
    TenLop  NVARCHAR(100) NOT NULL,
    MaKhoa  VARCHAR(10)   NOT NULL,
    CONSTRAINT FK_Lop_Khoa FOREIGN KEY (MaKhoa) REFERENCES Khoa(MaKhoa)
);

CREATE TABLE SinhVien (
    MaSV      VARCHAR(15)   PRIMARY KEY,
    HoTen     NVARCHAR(100) NOT NULL,
    NgaySinh  DATE          NULL,
    GioiTinh  NVARCHAR(5)   NULL CHECK (GioiTinh IN (N'Nam', N'Nữ')),
    DiaChi    NVARCHAR(200) NULL,
    MaLop     VARCHAR(20)   NOT NULL,
    CONSTRAINT FK_SinhVien_Lop FOREIGN KEY (MaLop) REFERENCES Lop(MaLop)
);

CREATE TABLE MonHoc (
    MaMon    VARCHAR(10)   PRIMARY KEY,
    TenMon   NVARCHAR(100) NOT NULL,
    SoTinChi INT           NOT NULL CHECK (SoTinChi > 0)
);

CREATE TABLE Diem (
    MaSV    VARCHAR(15) NOT NULL,
    MaMon   VARCHAR(10) NOT NULL,
    DiemSo  DECIMAL(4,2) NOT NULL CHECK (DiemSo BETWEEN 0 AND 10),
    CONSTRAINT PK_Diem PRIMARY KEY (MaSV, MaMon),
    CONSTRAINT FK_Diem_SinhVien FOREIGN KEY (MaSV)  REFERENCES SinhVien(MaSV),
    CONSTRAINT FK_Diem_MonHoc   FOREIGN KEY (MaMon) REFERENCES MonHoc(MaMon)
);
GO

-- Tai khoan: admin / D19CNPM3 
INSERT INTO TaiKhoan (TenDangNhap, MatKhauHash, QuyenHan) VALUES
('admin','90F6643D8043A7AEB91215E30580447817662E0DC4A5A45C155DA4FB2D329EA1', N'Admin');

INSERT INTO Khoa (MaKhoa, TenKhoa) VALUES
('CNTT', N'Công nghệ thông tin'),
('DIEN', N'Kỹ thuật điện'),
('KT',   N'Kế toán-tài cính'),
('CK',   N'Cơ khí-ô tô'),
('KD',   N'Kinh doanh-du lịch');


INSERT INTO Lop (MaLop, TenLop, MaKhoa) VALUES
('D19CNPM', N'Công nghệ phần mềm', 'CNTT'),
('D19HTTMDT', N'Hệ thống thương mại điện tử', 'CNTT'),
('D19H', N'Hệ thống điện', 'DIEN'),
('D19TDHHTD',   N'Tự động hóa', 'DIEN'),
('D19TCDN',   N'Tài chính doanh nghiệp',  'KT'),
('D19NGANHANG',   N'Ngân hàng',   'KT'),
('D19CKOTO',   N'Cơ khí ô tô',   'CK'),
('D19CKCTM',   N'Cơ khí chế tạo máy',   'CK'),
('D19QTDN',   N'Quản trị kinh doanh',   'KD'),
('D19KDTMTT',   N'Kinh doanh thương mại trực tuyến','KD');

INSERT INTO SinhVien (MaSV, HoTen, NgaySinh, GioiTinh, DiaChi, MaLop) VALUES
('SV001', N'Nguyễn Văn An',     '2006-03-12', N'Nam', N'Hà Nội',      'D19HTTMDT'),
('SV002', N'Phạm Hoàng Anh',    '2006-01-01', N'Nam', N'Hà Nam',      'D19CNPM'),
('SV003', N'Trần Thị Bình',     '2006-07-25', N'Nữ',  N'Hải Phòng',   'D19HTTMDT'),
('SV004', N'Vũ Đức Cường',      '2006-04-18', N'Nam', N'Nam Định',    'D19H'),
('SV005', N'Hoàng Văn Dũng',    '2006-09-05', N'Nam', N'Thái Bình',   'D19H'),
('SV006', N'Ngô Quang Duy',     '2006-02-14', N'Nam', N'Bắc Ninh',    'D19TDHHTD'),
('SV007', N'Phan Thị Giang',    '2006-10-22', N'Nữ',  N'Hưng Yên',    'D19TDHHTD'),
('SV008', N'Nguyễn Thị Hà',     '2006-06-30', N'Nữ',  N'Hà Nội',      'D19TCDN'),
('SV009', N'Bùi Thị Hạnh',      '2006-08-08', N'Nữ',  N'Ninh Bình',   'D19H'),
('SV010', N'Đinh Văn Hùng',     '2006-05-17', N'Nam', N'Thanh Hóa',   'D19TDHHTD'),
('SV011', N'Hoàng Quốc Huy',    '2006-09-17', N'Nam', N'Thái Bình',   'D19CKOTO'),
('SV012', N'Lê Thu Hương',      '2006-12-03', N'Nữ',  N'Nghệ An',     'D19TCDN'),
('SV013', N'Đỗ Minh Khôi',      '2006-11-11', N'Nam', N'Hải Dương',   'D19HTTMDT'),
('SV014', N'Trịnh Văn Kiên',    '2006-03-28', N'Nam', N'Vĩnh Phúc',   'D19TCDN'),
('SV015', N'Đặng Thị Lan',      '2006-05-02', N'Nữ',  N'Bắc Giang',   'D19NGANHANG'),
('SV016', N'Mai Thùy Linh',     '2006-01-19', N'Nữ',  N'Hà Nội',      'D19NGANHANG'),
('SV017', N'Lý Văn Long',       '2006-07-07', N'Nam', N'Lạng Sơn',    'D19NGANHANG'),
('SV018', N'Trần Văn Mạnh',     '2006-04-09', N'Nam', N'Phú Thọ',     'D19CKOTO'),
('SV019', N'Đặng Đức Minh',     '2006-02-19', N'Nam', N'Hà Nam',      'D19CKCTM'),
('SV020', N'Dương Đức Nam',     '2006-10-10', N'Nam', N'Hòa Bình',    'D19CKOTO'),
('SV021', N'Cao Văn Nghĩa',     '2006-06-15', N'Nam', N'Thái Nguyên', 'D19CKCTM'),
('SV022', N'Nguyễn Thị Ngọc',   '2006-08-21', N'Nữ',  N'Hải Phòng',   'D19QTDN'),
('SV023', N'Phạm Tuấn Phong',   '2006-11-12', N'Nam', N'Ninh Bình',   'D19CNPM'),
('SV024', N'Phạm Minh Quân',    '2006-03-03', N'Nam', N'Hà Nội',      'D19QTDN'),
('SV025', N'Tạ Quang Sơn',      '2006-12-20', N'Nam', N'Tuyên Quang', 'D19CKCTM'),
('SV026', N'Lê Trí Thành',      '2006-12-31', N'Nam', N'Hà Nội',      'D19CNPM'),
('SV027', N'Lương Thị Thảo',    '2006-09-26', N'Nữ',  N'Nam Định',    'D19QTDN'),
('SV028', N'Bùi Thanh Thủy',    '2006-08-14', N'Nữ',  N'Hà Nội',      'D19KDTMTT'),
('SV029', N'Đoàn Thị Trang',    '2006-04-27', N'Nữ',  N'Hưng Yên',    'D19KDTMTT'),
('SV030', N'Hồ Văn Tuấn',       '2006-07-13', N'Nam', N'Thanh Hóa',   'D19KDTMTT');

INSERT INTO MonHoc (MaMon, TenMon, SoTinChi) VALUES
('TRIET', N'Triết học Mác - Lênin',            2),
('TACB',  N'Tiếng Anh cơ bản',                 4),
('TIN',   N'Tin học đại cương',                2),
('LTNET', N'Lập trình .NET',                   4),
('CSDL',  N'Cơ sở dữ liệu',                    3),
('CTDL',  N'Cấu trúc dữ liệu và giải thuật',   3),
('CNPM',  N'Công nghệ phần mềm',               3),
('TMDT',  N'Thương mại điện tử căn bản',       2),
('HTTT',  N'Hệ thống thông tin quản lý',       3),
('MDIEN', N'Mạch điện',                        3),
('KTDT',  N'Kỹ thuật điện tử',                 3),
('DKTD',  N'Điều khiển tự động',               4),
('NLKT',  N'Nguyên lý kế toán',                2),
('KTVM',  N'Kinh tế vĩ mô',                    3),
('TCDN',  N'Tài chính doanh nghiệp',           3),
('NHTM',  N'Nghiệp vụ ngân hàng thương mại',   3),
('VKT',   N'Vẽ kỹ thuật',                      2),
('DCDT',  N'Động cơ đốt trong',                3),
('CNCTM', N'Công nghệ chế tạo máy',            3),
('QTH',   N'Quản trị học',                     3),
('MKT',   N'Marketing căn bản',                2),
('KDQT',  N'Kinh doanh quốc tế',               3);

INSERT INTO Diem (MaSV, MaMon, DiemSo) VALUES
('SV001','TRIET',7.5), ('SV001','TACB',6.0), ('SV001','TMDT',8.0),  ('SV001','HTTT',7.0),
('SV002','TRIET',6.5), ('SV002','TACB',8.5), ('SV002','LTNET',9.0), ('SV002','CNPM',8.5),
('SV003','TRIET',8.0), ('SV003','TACB',7.5), ('SV003','TMDT',8.5),  ('SV003','HTTT',9.0),
('SV004','TRIET',5.5), ('SV004','TACB',4.0), ('SV004','MDIEN',6.5), ('SV004','KTDT',5.0),
('SV005','TRIET',7.0), ('SV005','TACB',6.5), ('SV005','MDIEN',7.5), ('SV005','KTDT',8.0),
('SV006','TRIET',6.0), ('SV006','TACB',5.5), ('SV006','MDIEN',3.5), ('SV006','DKTD',6.0),
('SV007','TRIET',8.5), ('SV007','TACB',9.0), ('SV007','MDIEN',7.0), ('SV007','DKTD',7.5),
('SV008','TRIET',7.0), ('SV008','TACB',8.0), ('SV008','NLKT',8.5),  ('SV008','TCDN',7.5),
('SV009','TRIET',6.5), ('SV009','TACB',7.0), ('SV009','MDIEN',6.0), ('SV009','KTDT',5.5),
('SV010','TRIET',5.0), ('SV010','TACB',3.0), ('SV010','MDIEN',6.5), ('SV010','DKTD',7.0),
('SV011','TRIET',6.0), ('SV011','TACB',5.0), ('SV011','VKT',7.5),   ('SV011','DCDT',8.0),
('SV012','TRIET',9.0), ('SV012','TACB',8.5), ('SV012','NLKT',9.5),  ('SV012','TCDN',8.0),
('SV013','TRIET',7.5), ('SV013','TACB',7.0), ('SV013','TMDT',6.5),  ('SV013','HTTT',8.5),
('SV014','TRIET',4.5), ('SV014','TACB',6.0), ('SV014','NLKT',5.5),  ('SV014','TCDN',2.5),
('SV015','TRIET',8.0), ('SV015','TACB',7.5), ('SV015','KTVM',8.0),  ('SV015','NHTM',8.5),
('SV016','TRIET',8.5), ('SV016','TACB',9.5), ('SV016','KTVM',9.0),  ('SV016','NHTM',9.0),
('SV017','TRIET',6.0), ('SV017','TACB',5.5), ('SV017','KTVM',4.0),  ('SV017','NHTM',6.5),
('SV018','TRIET',5.5), ('SV018','TACB',4.5), ('SV018','VKT',6.0),   ('SV018','DCDT',7.0),
('SV019','TRIET',7.0), ('SV019','TACB',6.0), ('SV019','VKT',8.0),   ('SV019','CNCTM',7.5),
('SV020','TRIET',6.5), ('SV020','TACB',5.0), ('SV020','VKT',5.5),   ('SV020','DCDT',6.0),
('SV021','TRIET',3.5), ('SV021','TACB',5.5), ('SV021','VKT',6.0),   ('SV021','CNCTM',5.0),
('SV022','TRIET',8.0), ('SV022','TACB',8.0), ('SV022','QTH',7.5),   ('SV022','MKT',8.5),
('SV023','TRIET',7.0), ('SV023','TACB',7.5), ('SV023','LTNET',8.5), ('SV023','CNPM',9.0),
('SV024','TRIET',6.5), ('SV024','TACB',7.0), ('SV024','QTH',7.0),   ('SV024','MKT',6.0),
('SV025','TRIET',7.5), ('SV025','TACB',6.5), ('SV025','VKT',7.0),   ('SV025','CNCTM',8.0),
('SV026','TRIET',8.5), ('SV026','TACB',9.0), ('SV026','LTNET',10.0),('SV026','CNPM',9.5),
('SV027','TRIET',9.0), ('SV027','TACB',8.0), ('SV027','QTH',8.5),   ('SV027','MKT',9.0),
('SV028','TRIET',7.5), ('SV028','TACB',8.5), ('SV028','MKT',8.0),   ('SV028','KDQT',7.0),
('SV029','TRIET',6.0), ('SV029','TACB',7.0), ('SV029','MKT',5.5),   ('SV029','KDQT',6.5),
('SV030','TRIET',5.5), ('SV030','TACB',6.0), ('SV030','MKT',7.0),   ('SV030','KDQT',4.5);
GO

SELECT sv.MaSV, sv.HoTen, l.TenLop, k.TenKhoa
FROM SinhVien sv
JOIN Lop l  ON sv.MaLop = l.MaLop
JOIN Khoa k ON l.MaKhoa = k.MaKhoa;
GO

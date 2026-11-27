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
('KT',   N'Kế toán - Tài chính'),
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
('SV003', N'Nguyễn Thị Ánh',    '2006-01-21', N'Nữ',  N'Tuyên Quang', 'D19QTDN'),
('SV004', N'Nguyễn Gia Bảo',    '2006-01-17', N'Nam', N'Lạng Sơn',    'D19CKCTM'),
('SV005', N'Lê Thị Bích',       '2006-01-15', N'Nữ',  N'Hưng Yên',    'D19QTDN'),
('SV006', N'Trần Thị Bình',     '2006-07-25', N'Nữ',  N'Hải Phòng',   'D19HTTMDT'),
('SV007', N'Phạm Thị Châm',     '2006-08-31', N'Nữ',  N'Thái Nguyên', 'D19CKCTM'),
('SV008', N'Vũ Thị Chi',        '2006-08-12', N'Nữ',  N'Hưng Yên',    'D19H'),
('SV009', N'Lê Văn Chiến',      '2006-11-29', N'Nam', N'Hà Tĩnh',     'D19H'),
('SV010', N'Trần Đức Công',     '2006-10-26', N'Nam', N'Hưng Yên',    'D19TCDN'),
('SV011', N'Vũ Đức Cường',      '2006-04-18', N'Nam', N'Nam Định',    'D19H'),
('SV012', N'Đỗ Thị Diệp',       '2006-11-12', N'Nữ',  N'Hà Nội',      'D19CKOTO'),
('SV013', N'Hoàng Thị Dung',    '2006-07-10', N'Nữ',  N'Hà Nam',      'D19KDTMTT'),
('SV014', N'Hoàng Văn Dũng',    '2006-09-05', N'Nam', N'Thái Bình',   'D19H'),
('SV015', N'Ngô Quang Duy',     '2006-02-14', N'Nam', N'Bắc Ninh',    'D19TDHHTD'),
('SV016', N'Nguyễn Thùy Dương', '2006-05-23', N'Nữ',  N'Lạng Sơn',    'D19H'),
('SV017', N'Phạm Văn Đạt',      '2006-02-21', N'Nam', N'Thái Nguyên', 'D19CNPM'),
('SV018', N'Hoàng Minh Đức',    '2006-01-25', N'Nam', N'Tuyên Quang', 'D19TCDN'),
('SV019', N'Phan Thị Giang',    '2006-10-22', N'Nữ',  N'Hưng Yên',    'D19TDHHTD'),
('SV020', N'Nguyễn Thị Hà',     '2006-06-30', N'Nữ',  N'Hà Nội',      'D19TCDN'),
('SV021', N'Nguyễn Hữu Hải',    '2006-01-27', N'Nam', N'Nghệ An',     'D19CKOTO'),
('SV022', N'Bùi Thị Hạnh',      '2006-08-08', N'Nữ',  N'Ninh Bình',   'D19H'),
('SV023', N'Bùi Thị Hằng',      '2006-07-18', N'Nữ',  N'Hải Phòng',   'D19H'),
('SV024', N'Bùi Ngọc Hân',      '2006-08-11', N'Nữ',  N'Thái Bình',   'D19CKCTM'),
('SV025', N'Trần Thu Hiền',     '2006-11-04', N'Nữ',  N'Hà Tĩnh',     'D19CNPM'),
('SV026', N'Đỗ Trung Hiếu',     '2006-09-26', N'Nam', N'Hưng Yên',    'D19CKOTO'),
('SV027', N'Lê Thị Hoa',        '2006-01-02', N'Nữ',  N'Ninh Bình',   'D19HTTMDT'),
('SV028', N'Bùi Xuân Hòa',      '2006-07-29', N'Nam', N'Nam Định',    'D19CKOTO'),
('SV029', N'Ngô Văn Hoàng',     '2006-07-14', N'Nam', N'Hưng Yên',    'D19HTTMDT'),
('SV030', N'Phạm Thị Huệ',      '2006-02-15', N'Nữ',  N'Hòa Bình',    'D19TDHHTD'),
('SV031', N'Đinh Văn Hùng',     '2006-05-17', N'Nam', N'Thanh Hóa',   'D19TDHHTD'),
('SV032', N'Hoàng Quốc Huy',    '2006-09-17', N'Nam', N'Thái Bình',   'D19CKOTO'),
('SV033', N'Lê Gia Huy',        '2006-03-15', N'Nam', N'Hà Nội',      'D19TDHHTD'),
('SV034', N'Nguyễn Thị Huyền',  '2006-09-13', N'Nữ',  N'Hải Phòng',   'D19QTDN'),
('SV035', N'Lê Thu Hương',      '2006-12-03', N'Nữ',  N'Nghệ An',     'D19TCDN'),
('SV036', N'Phan Văn Khánh',    '2006-11-16', N'Nam', N'Tuyên Quang', 'D19HTTMDT'),
('SV037', N'Trần Đăng Khoa',    '2006-08-17', N'Nam', N'Lạng Sơn',    'D19H'),
('SV038', N'Đỗ Minh Khôi',      '2006-11-11', N'Nam', N'Hải Dương',   'D19HTTMDT'),
('SV039', N'Trịnh Văn Kiên',    '2006-03-28', N'Nam', N'Vĩnh Phúc',   'D19TCDN'),
('SV040', N'Nguyễn Tuấn Kiệt',  '2006-10-08', N'Nam', N'Ninh Bình',   'D19CNPM'),
('SV041', N'Đặng Thị Lan',      '2006-05-02', N'Nữ',  N'Bắc Giang',   'D19NGANHANG'),
('SV042', N'Vũ Hoàng Lâm',      '2006-03-06', N'Nam', N'Hà Nam',      'D19KDTMTT'),
('SV043', N'Mai Thị Liên',      '2006-07-27', N'Nữ',  N'Lạng Sơn',    'D19TDHHTD'),
('SV044', N'Mai Thùy Linh',     '2006-01-19', N'Nữ',  N'Hà Nội',      'D19NGANHANG'),
('SV045', N'Ngô Thị Loan',      '2006-03-19', N'Nữ',  N'Hòa Bình',    'D19CKCTM'),
('SV046', N'Lý Văn Long',       '2006-07-07', N'Nam', N'Lạng Sơn',    'D19NGANHANG'),
('SV047', N'Đặng Văn Lộc',      '2006-08-12', N'Nam', N'Thái Bình',   'D19TDHHTD'),
('SV048', N'Phạm Đức Lương',    '2006-06-06', N'Nam', N'Bắc Giang',   'D19KDTMTT'),
('SV049', N'Vũ Khánh Ly',       '2006-01-31', N'Nữ',  N'Hòa Bình',    'D19CNPM'),
('SV050', N'Trần Thị Mai',      '2006-04-22', N'Nữ',  N'Nam Định',    'D19QTDN'),
('SV051', N'Trần Văn Mạnh',     '2006-04-09', N'Nam', N'Phú Thọ',     'D19CKOTO'),
('SV052', N'Đặng Đức Minh',     '2006-02-19', N'Nam', N'Hà Nam',      'D19CKCTM'),
('SV053', N'Dương Đức Nam',     '2006-10-10', N'Nam', N'Hòa Bình',    'D19CKOTO'),
('SV054', N'Nguyễn Thị Nga',    '2006-07-26', N'Nữ',  N'Ninh Bình',   'D19CKOTO'),
('SV055', N'Dương Kim Ngân',    '2006-06-22', N'Nữ',  N'Hải Dương',   'D19CKCTM'),
('SV056', N'Cao Văn Nghĩa',     '2006-06-15', N'Nam', N'Thái Nguyên', 'D19CKCTM'),
('SV057', N'Nguyễn Thị Ngọc',   '2006-08-21', N'Nữ',  N'Hải Phòng',   'D19QTDN'),
('SV058', N'Đinh Thị Nguyệt',   '2006-11-10', N'Nữ',  N'Tuyên Quang', 'D19HTTMDT'),
('SV059', N'Hồ Minh Nhân',      '2006-10-18', N'Nam', N'Nam Định',    'D19TCDN'),
('SV060', N'Nguyễn Văn Nhật',   '2006-09-08', N'Nam', N'Lạng Sơn',    'D19NGANHANG'),
('SV061', N'Lê Hồng Nhung',     '2006-08-23', N'Nữ',  N'Hà Nội',      'D19QTDN'),
('SV062', N'Phan Thị Oanh',     '2006-03-21', N'Nữ',  N'Hòa Bình',    'D19KDTMTT'),
('SV063', N'Phạm Tuấn Phong',   '2006-11-12', N'Nam', N'Ninh Bình',   'D19CNPM'),
('SV064', N'Trịnh Công Phúc',   '2006-07-01', N'Nam', N'Thái Bình',   'D19CKOTO'),
('SV065', N'Trịnh Thu Phương',  '2006-08-26', N'Nữ',  N'Hòa Bình',    'D19H'),
('SV066', N'Đinh Văn Quang',    '2006-09-17', N'Nam', N'Hà Nội',      'D19CNPM'),
('SV067', N'Phạm Minh Quân',    '2006-03-03', N'Nam', N'Hà Nội',      'D19QTDN'),
('SV068', N'Nguyễn Văn Quyết',  '2006-02-14', N'Nam', N'Hà Nam',      'D19NGANHANG'),
('SV069', N'Hà Thị Quỳnh',      '2006-03-26', N'Nữ',  N'Quảng Ninh',  'D19NGANHANG'),
('SV070', N'Trần Minh Sang',    '2006-04-04', N'Nam', N'Hà Tĩnh',     'D19TCDN'),
('SV071', N'Lương Thị Sen',     '2006-10-20', N'Nữ',  N'Hà Nam',      'D19CKCTM'),
('SV072', N'Tạ Quang Sơn',      '2006-12-20', N'Nam', N'Tuyên Quang', 'D19CKCTM'),
('SV073', N'Lương Văn Tài',     '2006-08-23', N'Nam', N'Ninh Bình',   'D19NGANHANG'),
('SV074', N'Nguyễn Thanh Tâm',  '2006-06-15', N'Nữ',  N'Hà Tĩnh',     'D19QTDN'),
('SV075', N'Phạm Quốc Thái',    '2006-05-27', N'Nam', N'Bắc Giang',   'D19HTTMDT'),
('SV076', N'Lê Trí Thành',      '2006-12-31', N'Nam', N'Hà Nội',      'D19CNPM'),
('SV077', N'Lương Thị Thảo',    '2006-09-26', N'Nữ',  N'Nam Định',    'D19QTDN'),
('SV078', N'Vũ Văn Thắng',      '2006-03-01', N'Nam', N'Thanh Hóa',   'D19TCDN'),
('SV079', N'Nguyễn Đình Thiện', '2006-10-05', N'Nam', N'Hà Tĩnh',     'D19NGANHANG'),
('SV080', N'Đào Duy Thịnh',     '2006-05-11', N'Nam', N'Thái Nguyên', 'D19H'),
('SV081', N'Đào Thị Thoa',      '2006-11-17', N'Nữ',  N'Lạng Sơn',    'D19HTTMDT'),
('SV082', N'Cao Thị Thu',       '2006-05-17', N'Nữ',  N'Phú Thọ',     'D19CKOTO'),
('SV083', N'Bùi Thanh Thủy',    '2006-08-14', N'Nữ',  N'Hà Nội',      'D19KDTMTT'),
('SV084', N'Trần Thị Thúy',     '2006-05-15', N'Nữ',  N'Hà Nam',      'D19TDHHTD'),
('SV085', N'Hà Văn Toàn',       '2006-04-24', N'Nam', N'Phú Thọ',     'D19TDHHTD'),
('SV086', N'Đoàn Thị Trang',    '2006-04-27', N'Nữ',  N'Hưng Yên',    'D19KDTMTT'),
('SV087', N'Nguyễn Minh Trí',   '2006-04-26', N'Nam', N'Hòa Bình',    'D19KDTMTT'),
('SV088', N'Lê Quang Trung',    '2006-02-01', N'Nam', N'Thái Nguyên', 'D19TCDN'),
('SV089', N'Trần Anh Tú',       '2006-07-16', N'Nam', N'Ninh Bình',   'D19CNPM'),
('SV090', N'Hồ Văn Tuấn',       '2006-07-13', N'Nam', N'Thanh Hóa',   'D19KDTMTT'),
('SV091', N'Mạc Văn Tùng',      '2006-04-14', N'Nam', N'Hà Tĩnh',     'D19CKCTM'),
('SV092', N'Lê Thị Tuyết',      '2006-11-19', N'Nữ',  N'Quảng Ninh',  'D19NGANHANG'),
('SV093', N'Vũ Thị Uyên',       '2006-05-18', N'Nữ',  N'Vĩnh Phúc',   'D19HTTMDT'),
('SV094', N'Phạm Thị Vân',      '2006-04-21', N'Nữ',  N'Hà Nam',      'D19QTDN'),
('SV095', N'Nguyễn Hoàng Việt', '2006-05-22', N'Nam', N'Nghệ An',     'D19TCDN'),
('SV096', N'Phùng Văn Vinh',    '2006-02-21', N'Nam', N'Bắc Giang',   'D19TDHHTD'),
('SV097', N'Chu Đức Vũ',        '2006-08-29', N'Nam', N'Bắc Ninh',    'D19CNPM'),
('SV098', N'Nguyễn Thị Vy',     '2006-09-14', N'Nữ',  N'Nam Định',    'D19KDTMTT'),
('SV099', N'Hoàng Thị Xuân',    '2006-07-09', N'Nữ',  N'Phú Thọ',     'D19KDTMTT'),
('SV100', N'Đặng Thị Yến',      '2006-12-17', N'Nữ',  N'Hải Dương',   'D19NGANHANG');

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
('SV001','TRIET',9.0), ('SV001','TACB',7.0), ('SV001','TIN',6.5), ('SV001','TMDT',7.5), ('SV001','HTTT',5.5), ('SV001','CSDL',6.5),
('SV002','TRIET',6.0), ('SV002','TACB',7.0), ('SV002','TIN',7.5), ('SV002','LTNET',7.5), ('SV002','CNPM',7.5), ('SV002','CTDL',7.0),
('SV003','TRIET',6.0), ('SV003','TACB',8.0), ('SV003','TIN',8.0), ('SV003','QTH',4.5), ('SV003','MKT',7.0),
('SV004','TRIET',8.5), ('SV004','TACB',7.0), ('SV004','TIN',9.5), ('SV004','VKT',8.5), ('SV004','CNCTM',7.0),
('SV005','TRIET',7.0), ('SV005','TACB',9.5), ('SV005','TIN',7.0), ('SV005','QTH',5.5), ('SV005','MKT',5.5),
('SV006','TRIET',5.0), ('SV006','TACB',6.0), ('SV006','TIN',5.0), ('SV006','TMDT',5.0), ('SV006','HTTT',6.0), ('SV006','CSDL',7.0),
('SV007','TRIET',8.5), ('SV007','TACB',7.5), ('SV007','TIN',7.5), ('SV007','VKT',7.5), ('SV007','CNCTM',9.5),
('SV008','TRIET',6.0), ('SV008','TACB',5.0), ('SV008','TIN',5.5), ('SV008','MDIEN',5.5), ('SV008','KTDT',7.5),
('SV009','TRIET',4.0), ('SV009','TACB',6.5), ('SV009','TIN',6.0), ('SV009','MDIEN',6.0), ('SV009','KTDT',7.0),
('SV010','TRIET',2.0), ('SV010','TACB',4.0), ('SV010','TIN',6.0), ('SV010','NLKT',4.5), ('SV010','TCDN',4.0),
('SV011','TRIET',8.0), ('SV011','TACB',9.0), ('SV011','TIN',8.0), ('SV011','MDIEN',6.5), ('SV011','KTDT',6.5),
('SV012','TRIET',6.5), ('SV012','TACB',6.0), ('SV012','TIN',5.5), ('SV012','VKT',7.5), ('SV012','DCDT',7.5),
('SV013','TRIET',6.0), ('SV013','TACB',6.5), ('SV013','TIN',6.0), ('SV013','MKT',5.5), ('SV013','KDQT',3.5),
('SV014','TRIET',5.0), ('SV014','TACB',8.0), ('SV014','TIN',6.5), ('SV014','MDIEN',3.5), ('SV014','KTDT',6.0),
('SV015','TRIET',8.5), ('SV015','TACB',10.0), ('SV015','TIN',7.5), ('SV015','MDIEN',7.5), ('SV015','DKTD',7.5),
('SV016','TRIET',9.0), ('SV016','TACB',9.0), ('SV016','TIN',10.0), ('SV016','MDIEN',9.0), ('SV016','KTDT',5.5),
('SV017','TRIET',4.0), ('SV017','TACB',5.5), ('SV017','TIN',6.5), ('SV017','LTNET',5.0), ('SV017','CNPM',7.0), ('SV017','CTDL',6.5),
('SV018','TRIET',6.0), ('SV018','TACB',8.0), ('SV018','TIN',8.0), ('SV018','NLKT',7.5), ('SV018','TCDN',6.0),
('SV019','TRIET',9.0), ('SV019','TACB',5.5), ('SV019','TIN',7.0), ('SV019','MDIEN',7.5), ('SV019','DKTD',6.0),
('SV020','TRIET',8.0), ('SV020','TACB',9.5), ('SV020','TIN',10.0), ('SV020','NLKT',9.0), ('SV020','TCDN',9.0),
('SV021','TRIET',7.0), ('SV021','TACB',3.5), ('SV021','TIN',6.0), ('SV021','VKT',4.5), ('SV021','DCDT',3.0),
('SV022','TRIET',5.0), ('SV022','TACB',6.5), ('SV022','TIN',4.0), ('SV022','MDIEN',5.5), ('SV022','KTDT',6.0),
('SV023','TRIET',5.0), ('SV023','TACB',6.0), ('SV023','TIN',6.0), ('SV023','MDIEN',3.5), ('SV023','KTDT',5.5),
('SV024','TRIET',6.5), ('SV024','TACB',7.0), ('SV024','TIN',7.5), ('SV024','VKT',8.5), ('SV024','CNCTM',7.0),
('SV025','TRIET',4.5), ('SV025','TACB',7.5), ('SV025','TIN',8.5), ('SV025','LTNET',5.5), ('SV025','CNPM',6.5), ('SV025','CTDL',7.5),
('SV026','TRIET',6.5), ('SV026','TACB',6.5), ('SV026','TIN',4.5), ('SV026','VKT',9.0), ('SV026','DCDT',5.5),
('SV027','TRIET',5.0), ('SV027','TACB',6.0), ('SV027','TIN',6.5), ('SV027','TMDT',4.5), ('SV027','HTTT',5.0), ('SV027','CSDL',5.0),
('SV028','TRIET',7.5), ('SV028','TACB',6.0), ('SV028','TIN',7.5), ('SV028','VKT',8.0), ('SV028','DCDT',7.0),
('SV029','TRIET',4.0), ('SV029','TACB',6.5), ('SV029','TIN',7.5), ('SV029','TMDT',5.0), ('SV029','HTTT',3.5), ('SV029','CSDL',2.5),
('SV030','TRIET',6.5), ('SV030','TACB',6.5), ('SV030','TIN',4.5), ('SV030','MDIEN',5.0), ('SV030','DKTD',5.5),
('SV031','TRIET',4.0), ('SV031','TACB',6.5), ('SV031','TIN',5.0), ('SV031','MDIEN',5.5), ('SV031','DKTD',6.5),
('SV032','TRIET',8.5), ('SV032','TACB',6.0), ('SV032','TIN',7.5), ('SV032','VKT',5.0), ('SV032','DCDT',7.5),
('SV033','TRIET',7.5), ('SV033','TACB',8.5), ('SV033','TIN',5.0), ('SV033','MDIEN',6.0), ('SV033','DKTD',7.5),
('SV034','TRIET',5.0), ('SV034','TACB',6.0), ('SV034','TIN',6.0), ('SV034','QTH',5.5), ('SV034','MKT',4.5),
('SV035','TRIET',6.0), ('SV035','TACB',8.0), ('SV035','TIN',7.5), ('SV035','NLKT',7.5), ('SV035','TCDN',9.5),
('SV036','TRIET',7.0), ('SV036','TACB',8.0), ('SV036','TIN',7.0), ('SV036','TMDT',8.0), ('SV036','HTTT',7.5), ('SV036','CSDL',7.0),
('SV037','TRIET',6.0), ('SV037','TACB',6.5), ('SV037','TIN',4.5), ('SV037','MDIEN',6.5), ('SV037','KTDT',5.0),
('SV038','TRIET',6.0), ('SV038','TACB',7.5), ('SV038','TIN',4.0), ('SV038','TMDT',6.0), ('SV038','HTTT',7.0), ('SV038','CSDL',9.0),
('SV039','TRIET',7.5), ('SV039','TACB',7.5), ('SV039','TIN',10.0), ('SV039','NLKT',8.5), ('SV039','TCDN',9.0),
('SV040','TRIET',6.0), ('SV040','TACB',9.5), ('SV040','TIN',6.5), ('SV040','LTNET',6.0), ('SV040','CNPM',7.0), ('SV040','CTDL',8.0),
('SV041','TRIET',8.5), ('SV041','TACB',4.5), ('SV041','TIN',7.0), ('SV041','KTVM',5.5), ('SV041','NHTM',7.5),
('SV042','TRIET',4.5), ('SV042','TACB',4.5), ('SV042','TIN',6.5), ('SV042','MKT',6.0), ('SV042','KDQT',4.5),
('SV043','TRIET',7.0), ('SV043','TACB',7.0), ('SV043','TIN',7.0), ('SV043','MDIEN',5.5), ('SV043','DKTD',5.5),
('SV044','TRIET',6.0), ('SV044','TACB',7.5), ('SV044','TIN',8.0), ('SV044','KTVM',6.0), ('SV044','NHTM',8.0),
('SV045','TRIET',6.0), ('SV045','TACB',8.5), ('SV045','TIN',6.5), ('SV045','VKT',8.5), ('SV045','CNCTM',9.0),
('SV046','TRIET',8.0), ('SV046','TACB',6.0), ('SV046','TIN',5.0), ('SV046','KTVM',8.0), ('SV046','NHTM',5.0),
('SV047','TRIET',5.5), ('SV047','TACB',8.0), ('SV047','TIN',8.0), ('SV047','MDIEN',7.5), ('SV047','DKTD',7.5),
('SV048','TRIET',8.5), ('SV048','TACB',9.0), ('SV048','TIN',9.0), ('SV048','MKT',5.5), ('SV048','KDQT',6.0),
('SV049','TRIET',9.0), ('SV049','TACB',6.5), ('SV049','TIN',10.0), ('SV049','LTNET',8.0), ('SV049','CNPM',6.5), ('SV049','CTDL',6.5),
('SV050','TRIET',7.5), ('SV050','TACB',10.0), ('SV050','TIN',9.0), ('SV050','QTH',7.0), ('SV050','MKT',7.5),
('SV051','TRIET',6.0), ('SV051','TACB',8.0), ('SV051','TIN',9.0), ('SV051','VKT',8.0), ('SV051','DCDT',7.0),
('SV052','TRIET',9.5), ('SV052','TACB',8.0), ('SV052','TIN',7.5), ('SV052','VKT',6.5), ('SV052','CNCTM',9.5),
('SV053','TRIET',7.5), ('SV053','TACB',6.5), ('SV053','TIN',6.5), ('SV053','VKT',10.0), ('SV053','DCDT',7.5),
('SV054','TRIET',4.0), ('SV054','TACB',5.0), ('SV054','TIN',5.5), ('SV054','VKT',8.5), ('SV054','DCDT',3.5),
('SV055','TRIET',6.5), ('SV055','TACB',6.0), ('SV055','TIN',7.5), ('SV055','VKT',5.0), ('SV055','CNCTM',6.5),
('SV056','TRIET',5.5), ('SV056','TACB',5.5), ('SV056','TIN',5.0), ('SV056','VKT',6.0), ('SV056','CNCTM',7.0),
('SV057','TRIET',5.0), ('SV057','TACB',4.5), ('SV057','TIN',6.5), ('SV057','QTH',6.0), ('SV057','MKT',8.0),
('SV058','TRIET',9.5), ('SV058','TACB',6.5), ('SV058','TIN',7.0), ('SV058','TMDT',6.5), ('SV058','HTTT',5.5), ('SV058','CSDL',7.5),
('SV059','TRIET',6.5), ('SV059','TACB',7.0), ('SV059','TIN',10.0), ('SV059','NLKT',8.5), ('SV059','TCDN',6.5),
('SV060','TRIET',6.5), ('SV060','TACB',8.0), ('SV060','TIN',7.0), ('SV060','KTVM',7.0), ('SV060','NHTM',4.5),
('SV061','TRIET',10.0), ('SV061','TACB',8.0), ('SV061','TIN',9.5), ('SV061','QTH',7.0), ('SV061','MKT',10.0),
('SV062','TRIET',3.5), ('SV062','TACB',5.5), ('SV062','TIN',6.5), ('SV062','MKT',5.5), ('SV062','KDQT',5.0),
('SV063','TRIET',7.5), ('SV063','TACB',4.0), ('SV063','TIN',6.0), ('SV063','LTNET',5.0), ('SV063','CNPM',5.0), ('SV063','CTDL',3.5),
('SV064','TRIET',5.5), ('SV064','TACB',5.0), ('SV064','TIN',6.5), ('SV064','VKT',5.5), ('SV064','DCDT',5.0),
('SV065','TRIET',4.5), ('SV065','TACB',7.0), ('SV065','TIN',7.5), ('SV065','MDIEN',6.0), ('SV065','KTDT',4.0),
('SV066','TRIET',8.5), ('SV066','TACB',7.0), ('SV066','TIN',7.0), ('SV066','LTNET',10.0), ('SV066','CNPM',10.0), ('SV066','CTDL',10.0),
('SV067','TRIET',8.0), ('SV067','TACB',8.0), ('SV067','TIN',7.0), ('SV067','QTH',5.5), ('SV067','MKT',7.0),
('SV068','TRIET',6.0), ('SV068','TACB',10.0), ('SV068','TIN',5.5), ('SV068','KTVM',7.0), ('SV068','NHTM',9.0),
('SV069','TRIET',10.0), ('SV069','TACB',9.5), ('SV069','TIN',6.0), ('SV069','KTVM',10.0), ('SV069','NHTM',9.0),
('SV070','TRIET',8.0), ('SV070','TACB',8.0), ('SV070','TIN',7.0), ('SV070','NLKT',8.0), ('SV070','TCDN',5.0),
('SV071','TRIET',8.0), ('SV071','TACB',8.5), ('SV071','TIN',5.5), ('SV071','VKT',8.0), ('SV071','CNCTM',9.5),
('SV072','TRIET',7.0), ('SV072','TACB',6.5), ('SV072','TIN',5.0), ('SV072','VKT',5.0), ('SV072','CNCTM',4.5),
('SV073','TRIET',4.0), ('SV073','TACB',6.0), ('SV073','TIN',6.0), ('SV073','KTVM',5.0), ('SV073','NHTM',6.0),
('SV074','TRIET',7.0), ('SV074','TACB',6.0), ('SV074','TIN',3.0), ('SV074','QTH',5.0), ('SV074','MKT',5.5),
('SV075','TRIET',8.5), ('SV075','TACB',9.0), ('SV075','TIN',8.0), ('SV075','TMDT',7.0), ('SV075','HTTT',7.5), ('SV075','CSDL',6.5),
('SV076','TRIET',6.0), ('SV076','TACB',7.0), ('SV076','TIN',8.5), ('SV076','LTNET',3.5), ('SV076','CNPM',4.0), ('SV076','CTDL',6.5),
('SV077','TRIET',7.0), ('SV077','TACB',4.5), ('SV077','TIN',5.5), ('SV077','QTH',8.0), ('SV077','MKT',4.5),
('SV078','TRIET',7.5), ('SV078','TACB',6.5), ('SV078','TIN',8.0), ('SV078','NLKT',7.5), ('SV078','TCDN',6.5),
('SV079','TRIET',6.0), ('SV079','TACB',7.0), ('SV079','TIN',4.5), ('SV079','KTVM',7.0), ('SV079','NHTM',7.5),
('SV080','TRIET',7.5), ('SV080','TACB',7.0), ('SV080','TIN',3.5), ('SV080','MDIEN',8.5), ('SV080','KTDT',8.0),
('SV081','TRIET',8.0), ('SV081','TACB',4.5), ('SV081','TIN',9.5), ('SV081','TMDT',6.5), ('SV081','HTTT',7.0), ('SV081','CSDL',7.5),
('SV082','TRIET',4.0), ('SV082','TACB',5.0), ('SV082','TIN',7.0), ('SV082','VKT',7.0), ('SV082','DCDT',6.5),
('SV083','TRIET',4.0), ('SV083','TACB',6.5), ('SV083','TIN',7.0), ('SV083','MKT',7.0), ('SV083','KDQT',7.5),
('SV084','TRIET',8.0), ('SV084','TACB',9.0), ('SV084','TIN',7.0), ('SV084','MDIEN',6.5), ('SV084','DKTD',8.5),
('SV085','TRIET',6.5), ('SV085','TACB',6.5), ('SV085','TIN',4.5), ('SV085','MDIEN',6.5), ('SV085','DKTD',7.5),
('SV086','TRIET',8.5), ('SV086','TACB',10.0), ('SV086','TIN',7.5), ('SV086','MKT',8.5), ('SV086','KDQT',8.5),
('SV087','TRIET',9.0), ('SV087','TACB',7.0), ('SV087','TIN',6.5), ('SV087','MKT',6.5), ('SV087','KDQT',7.0),
('SV088','TRIET',4.5), ('SV088','TACB',6.0), ('SV088','TIN',4.0), ('SV088','NLKT',5.5), ('SV088','TCDN',6.0),
('SV089','TRIET',9.0), ('SV089','TACB',7.0), ('SV089','TIN',6.0), ('SV089','LTNET',7.5), ('SV089','CNPM',6.0), ('SV089','CTDL',7.5),
('SV090','TRIET',4.5), ('SV090','TACB',5.5), ('SV090','TIN',9.5), ('SV090','MKT',8.0), ('SV090','KDQT',8.5),
('SV091','TRIET',7.5), ('SV091','TACB',5.5), ('SV091','TIN',6.0), ('SV091','VKT',6.5), ('SV091','CNCTM',8.0),
('SV092','TRIET',6.0), ('SV092','TACB',5.0), ('SV092','TIN',9.5), ('SV092','KTVM',8.0), ('SV092','NHTM',8.5),
('SV093','TRIET',8.5), ('SV093','TACB',8.5), ('SV093','TIN',7.0), ('SV093','TMDT',8.5), ('SV093','HTTT',8.0), ('SV093','CSDL',7.5),
('SV094','TRIET',6.0), ('SV094','TACB',6.0), ('SV094','TIN',8.5), ('SV094','QTH',8.5), ('SV094','MKT',7.0),
('SV095','TRIET',7.0), ('SV095','TACB',9.5), ('SV095','TIN',8.0), ('SV095','NLKT',10.0), ('SV095','TCDN',7.5),
('SV096','TRIET',7.5), ('SV096','TACB',4.0), ('SV096','TIN',6.0), ('SV096','MDIEN',7.0), ('SV096','DKTD',4.0),
('SV097','TRIET',6.0), ('SV097','TACB',6.5), ('SV097','TIN',6.0), ('SV097','LTNET',5.5), ('SV097','CNPM',7.5), ('SV097','CTDL',5.0),
('SV098','TRIET',8.5), ('SV098','TACB',8.0), ('SV098','TIN',7.5), ('SV098','MKT',7.0), ('SV098','KDQT',7.0),
('SV099','TRIET',6.5), ('SV099','TACB',4.5), ('SV099','TIN',6.0), ('SV099','MKT',7.5), ('SV099','KDQT',6.5),
('SV100','TRIET',7.0), ('SV100','TACB',5.5), ('SV100','TIN',6.0), ('SV100','KTVM',6.0), ('SV100','NHTM',6.0);
GO

SELECT sv.MaSV, sv.HoTen, l.TenLop, k.TenKhoa
FROM SinhVien sv
JOIN Lop l  ON sv.MaLop = l.MaLop
JOIN Khoa k ON l.MaKhoa = k.MaKhoa;
GO
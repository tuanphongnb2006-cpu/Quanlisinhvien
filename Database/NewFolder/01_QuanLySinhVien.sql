-- =============================================
-- Database: QuanLySinhVien
-- Chay file nay trong SSMS (nhan F5)
-- =============================================
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

-- ---------- TAO BANG ----------
CREATE TABLE TaiKhoan (
    MaTK         INT IDENTITY(1,1) PRIMARY KEY,
    TenDangNhap  VARCHAR(50)  NOT NULL UNIQUE,
    MatKhauHash  VARCHAR(64)  NOT NULL,          -- SHA-256 dang HEX
    QuyenHan     NVARCHAR(20) NOT NULL DEFAULT N'NhanVien'
        CHECK (QuyenHan IN (N'Admin', N'NhanVien'))
);

CREATE TABLE Khoa (
    MaKhoa  VARCHAR(10)   PRIMARY KEY,
    TenKhoa NVARCHAR(100) NOT NULL
);

CREATE TABLE Lop (
    MaLop   VARCHAR(10)   PRIMARY KEY,
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
    MaLop     VARCHAR(10)   NOT NULL,
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

-- ---------- DU LIEU MAU ----------
-- Tai khoan: admin / 123456  (mat khau luu dang SHA-256)
INSERT INTO TaiKhoan (TenDangNhap, MatKhauHash, QuyenHan) VALUES
('admin', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', N'Admin');

INSERT INTO Khoa (MaKhoa, TenKhoa) VALUES
('CNTT', N'Công nghệ thông tin'),
('DIEN', N'Điện'),
('KT',   N'Kinh tế');

INSERT INTO Lop (MaLop, TenLop, MaKhoa) VALUES
('D19CNPM3', N'Công nghệ phần mềm 3', 'CNTT'),
('D19HTTT1', N'Hệ thống thông tin 1',  'CNTT'),
('D19DIEN1', N'Điện 1',                'DIEN'),
('D19KT1',   N'Kinh tế 1',             'KT');

INSERT INTO SinhVien (MaSV, HoTen, NgaySinh, GioiTinh, DiaChi, MaLop) VALUES
('SV001', N'Nguyễn Văn An',    '2006-03-12', N'Nam', N'Hà Nội',    'D19CNPM3'),
('SV002', N'Trần Thị Bình',    '2006-07-25', N'Nữ',  N'Hải Phòng', 'D19CNPM3'),
('SV003', N'Lê Minh Cường',    '2006-01-08', N'Nam', N'Nam Định',  'D19CNPM3'),
('SV004', N'Phạm Thu Hà',      '2006-11-30', N'Nữ',  N'Hà Nội',    'D19HTTT1'),
('SV005', N'Hoàng Quốc Huy',   '2005-09-17', N'Nam', N'Thái Bình', 'D19HTTT1'),
('SV006', N'Vũ Ngọc Lan',      '2006-05-02', N'Nữ',  N'Bắc Ninh',  'D19DIEN1'),
('SV007', N'Đặng Đức Minh',    '2006-02-19', N'Nam', N'Hà Nam',    'D19DIEN1'),
('SV008', N'Bùi Thanh Thủy',   '2006-08-14', N'Nữ',  N'Hà Nội',    'D19KT1');

INSERT INTO MonHoc (MaMon, TenMon, SoTinChi) VALUES
('LTNET', N'Lập trình .NET',        3),
('CSDL',  N'Cơ sở dữ liệu',         3),
('CTDL',  N'Cấu trúc dữ liệu',      3),
('TIN',   N'Tin học đại cương',     2);

INSERT INTO Diem (MaSV, MaMon, DiemSo) VALUES
('SV001', 'LTNET', 8.5), ('SV001', 'CSDL', 7.5), ('SV001', 'CTDL', 6.5),
('SV002', 'LTNET', 9.0), ('SV002', 'CSDL', 8.0),
('SV003', 'LTNET', 5.5), ('SV003', 'CTDL', 4.5),
('SV004', 'CSDL',  7.0), ('SV004', 'TIN',  9.5),
('SV005', 'LTNET', 6.0), ('SV005', 'CSDL', 6.5),
('SV006', 'TIN',   8.0),
('SV007', 'TIN',   7.0),
('SV008', 'TIN',   9.0);
GO

-- ---------- KIEM TRA ----------
SELECT sv.MaSV, sv.HoTen, l.TenLop, k.TenKhoa
FROM SinhVien sv
JOIN Lop l  ON sv.MaLop = l.MaLop
JOIN Khoa k ON l.MaKhoa = k.MaKhoa;
GO

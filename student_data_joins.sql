-- Joining all tables below
SELECT 
    master..[1swdaily].Student,
    master..[1swdaily].[Period],
    -- Daily Grades
    master..[1swdaily].a11, master..[1swdaily].a12, master..[1swdaily].a13, master..[1swdaily].a14, 
    master..[1swdaily].a15, master..[1swdaily].a16, master..[1swdaily].a17, master..[1swdaily].a18, 
    master..[1swdaily].a19, master..[1swdaily].a110, master..[1swdaily].a111, master..[1swdaily].a112,
    master..[2swdaily].a21, master..[2swdaily].a22, master..[2swdaily].a23, master..[2swdaily].a24,
    master..[2swdaily].a25, master..[2swdaily].a26, master..[2swdaily].a27, master..[2swdaily].a28,
    master..[2swdaily].a29, master..[2swdaily].a210, master..[2swdaily].a211, master..[2swdaily].a212,
    master..[3swdaily].a31, master..[3swdaily].a32, master..[3swdaily].a33, master..[3swdaily].a34,
    master..[3swdaily].a35, master..[3swdaily].a36,  master..[3swdaily].a37, master..[3swdaily].a38,
    master..[3swdaily].a39,  master..[3swdaily].a310, master..[3swdaily].a311, master..[3swdaily].a312,
    -- Test Grades
    master..[1swtest].t1, master..[2swtest].t2, master..[3swtest].t3

FROM master..[1swdaily]

LEFT JOIN master..[1swtest]
    ON master..[1swdaily].[Id] = master..[1swtest].[Id]
LEFT JOIN master..[2swdaily]
    ON master..[1swtest].[Id] = master..[2swdaily].[Id]
LEFT JOIN master..[2swtest]
    ON master..[2swdaily].[Id] = master..[2swtest].[Id]
LEFT JOIN master..[3swdaily]
    ON master..[2swtest].[Id] = master..[3swdaily].[Id]
LEFT JOIN master..[3swtest]
    ON master..[3swdaily].[Id] = master..[3swtest].[Id]

SELECT AVG(t1)
FROM master..[1swtest]

SELECT AVG(t2)
FROM master..[2swtest]

SELECT AVG(t3)
FROM master..[3swtest]